require File.join(File.dirname(__FILE__), 'music_element')
require File.join(File.dirname(__FILE__), 'modifiers/attack_decay')
require File.join(File.dirname(__FILE__), 'modifiers/chord_intervals')
require 'forwardable'

module Stretto
  module MusicElements

    # A chord indicates a group of notes that can be played together.
    #
    # The most common chord is a named chord. This is indicated by a note string
    # (see {Note}) and the name of the chord. For example, chord C major is
    # represented by +Cmaj+, and it will consist on the notes C, E and G (for definition,
    # according to the musical theory).
    #
    # The chord can also indicate a duration (see {Duration}) and attack and decay (see
    # {AttackDecay}), which have to be inserted after the named chord. For example, the chord
    # +C#5maj7wa80d100+ has a base note of +C#5+, is the major 7th chord (+maj7+) with a
    # whole duration (+w+), and has attack 80 and decay 100 (+a80d100+). The default octave
    # for chords is 3
    #
    # For a list of supported chords see the JFugue reference guide, or the source code
    # for {CHORD_INTERVALS}
    #
    # A chord can be inverted; that is, some of its notes is raised or lowered an octave, also
    # called as the voicing of a chord. Chord inversions can be specified by two ways.
    # The first one is to indicate with the symbol +^+ the number of notes that will be raised
    # a whole octave (for example, the chord +C5maj+ will have notes C5, E5 and G5, its
    # inversion +C5maj^+ will have E5, G5 and E6, and +C5maj^^+ notes G5, C6 and E6). The other
    # way is to indicate explicitely the pivot note to invert from (the note +C5maj^E5+ is
    # equivalent to the first inversion). It will raise an error if a chord is tried to
    # be inverted by a note that is not part of the chord.
    #
    # This class can also hold non-regular chords, called harmonic chords. See {HarmonicChord}
    class Chord < MusicElement

      include Duration
      include AttackDecay

      DEFAULT_OCTAVE = 3

      attr_reader :original_named_chord, :named_chord
      attr_reader :key_signature
      attr_accessor :instrument

      extend Forwardable
      def_delegators :@base_note, :original_accidental, :accidental,
                                  :original_pitch,      :pitch,
                                  :original_key,        :key,
                                  :original_octave,     :octave,
                                  :original_attack,     :attack,
                                  :original_decay,      :decay

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_chord!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        unless @notes = token[:notes]
          build_duration_from_token(token[:duration])
          @original_base_note   = token[:base_note]
          @original_named_chord = token[:named_chord]
          @named_chord          = @original_named_chord.downcase
          @original_inversions  = token[:inversions]
          @base_note            = base_note
          build_attack_and_decay(token[:attack], token[:decay])
        end
      end

      # @return [Array(MusicElements::Note)] The array of notes generated by this chord
      def notes
        unless @notes
          build_chord_notes(@named_chord)
          build_inversions
        end
        @notes
      end

      # Returns the base note of the chord, that is, the note the chord was specified with.
      #
      # Note that this is not necessarily equal to the first note in the chord. If it has
      # inversions, the base note will be kept as the original note, but the
      # +notes+ construct will be effectively transposed.
      def base_note
        @base_note || build_base_note(@original_base_note)
      end

      # @return [Boolean] True if all the notes of the chord are equal
      # @see MusicElements::Note#==
      def ==(other)
        notes && notes == other.notes
      end

      # @return [Number] The number of inversions of the chord
      # @example
      #    Chord.new("Cmaj^^").inversions # => 2
      def inversions
        build_inversions unless @inversions
        @inversions
      end

      # @return [MusicElements::Note] The pivot note in which do the inversion, if specified
      # @example
      #   Chord.new("Cmaj^E").pivot_note # => Note<@key="E">
      def pivot_note
        build_inversions unless @pivot_note
        @pivot_note
      end

      # Assigns the key signature for the chord, and for all of its notes.
      #
      # @see MusicElements::Note#key_signature=
      def key_signature=(key_signature)
        @key_signature = key_signature
        if @base_note
          @base_note.key_signature = key_signature
          build_chord_notes(@named_chord)
          build_inversions
        end
        @notes.each{ |note| note.pattern = @pattern }
      end

      def play(player)
        if !((start_of_tie? && end_of_tie?) || end_of_tie?)          
          duration = 60.0 / player.bpm * tied_duration * player.default_beat
          notes.each do |note|
            player.midi.note_on(note.pitch, player.channel, attack)
          end
          player.midi.rest(duration)
          notes.each do |note|
            player.midi.note_off(note.pitch, player.channel, decay)
          end
        end
      end
      
      private

        # Builds the nase_note according to the parsed token
        def build_base_note(base_note_options)
          Note.new({
              :text_value => base_note_options[:text_value],
              :octave     => base_note_options[:octave] || DEFAULT_OCTAVE,
              :accidental => base_note_options[:accidental],
              :key        => base_note_options[:key],
              :pitch      => base_note_options[:pitch],
              :attack     => base_note_options[:attack],
              :decay      => base_note_options[:decay],
              :duration   => base_note_options[:duration] },
            @pattern
          )
        end

        # When a named chord is specified, returns an array of the notes consisting
        # on the base note plus the note with the intervals applied
        def build_chord_notes(named_chord)
          @named_chord = named_chord
          intervals   = CHORD_INTERVALS[@named_chord]
          @notes = [@base_note] + intervals.map{|interval| @base_note + interval}
        end

        # Builds either implicit (+^+) or explicit (+^+_note_) inversions
        def build_inversions
          if @original_inversions
            @inversions = @original_inversions[:inversions]
            pivot_note  = @original_inversions[:pivot_note]
            if pivot_note
              @pivot_note = Note.new({
                  :text_value => pivot_note.text_value,
                  :key        => pivot_note.key,
                  :pitch      => pivot_note.pitch,
                  :accidental => pivot_note.accidental,
                  :octave     => pivot_note.octave || DEFAULT_OCTAVE,
                  :duration   => @original_duration_token,
                  :attack     => @original_attack,
                  :decay      => @original_decay
              }, @pattern)
              @pivot_note.pattern = @pattern
            end
          else
            @inversions = 0
          end
          raise Exceptions::ChordInversionsException.new("Number of inversions (#{@inversions}) is greater than chord size (#{notes.size})") if @inversions >= notes.size

          notes.each{ |note| note.pattern = @pattern }
          if @pivot_note
            actual_pivot = notes.index { |note| @pivot_note.pitch == note.pitch }
            raise Exceptions::ChordInversionsException.new("Note #{@pivot_note.original_string}(#{@pivot_note.pitch}) does not belong to chord #{@original_string}") unless actual_pivot
            actual_pivot.times { notes << notes.shift + 12 }
          else
            @inversions.times  { notes << notes.shift + 12 }
          end
        end


        # @private
        # @see MusicElements::MusicElement#substitute_variables!
        def substitute_variables!
          @base_note.pattern = @pattern
          build_chord_notes(@named_chord)
          build_inversions
        end

    end

  end
end
