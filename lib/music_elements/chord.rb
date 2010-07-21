require File.join(File.dirname(__FILE__), 'music_element')
require 'forwardable'

module Stretto
  module MusicElements

    class Chord < MusicElement

      include Duration

      CHORD_INTERVALS = {
        'maj'       => [4, 7],
        'min'       => [3, 7],
        'aug'       => [4, 8],
        'dim'       => [3, 6],
        'dom7'      => [4, 7, 10],
        'maj7'      => [4, 7, 11],
        'min7'      => [3, 7, 10],
        'sus4'      => [5, 7],
        'sus2'      => [2, 7],
        'maj6'      => [4, 7, 9],
        'min6'      => [3, 7, 9],
        'dom9'      => [4, 7, 10, 14],
        'maj9'      => [4, 7, 11, 14],
        'min9'      => [3, 7, 10, 14],
        'dim7'      => [3, 6, 9],
        'add9'      => [4, 7, 14],
        'min11'     => [7, 10, 14, 15, 17],
        'dom11'     => [7, 10, 14, 17],
        'dom13'     => [7, 10, 14, 16, 21],
        'min13'     => [7, 10, 14, 15, 21],
        'maj13'     => [7, 11, 14, 16, 21],
        'dom7<5'    => [4, 6, 10],
        'dom7>5'    => [4, 8, 10],
        'maj7<5'    => [4, 6, 11],
        'maj7>5'    => [4, 8, 11],
        'minmaj7'   => [3, 7, 11],
        'dom7<5<9'  => [4, 6, 10, 13],
        'dom7<5>9'  => [4, 6, 10, 15],
        'dom7>5<9'  => [4, 8, 10, 13],
        'dom7>5>9'  => [4, 8, 10, 15]
      }

      DEFAULT_OCTAVE = 3

      attr_reader :original_named_chord, :named_chord
      attr_reader :key_signature

      extend Forwardable
      def_delegators :@base_note, :original_accidental, :accidental,
                                  :original_pitch,      :pitch,
                                  :original_key,        :key,
                                  :original_octave,     :octave,
                                  :original_attack,     :attack,
                                  :original_decay,      :decay

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_chord!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        unless @notes = token[:notes]
          build_duration_from_token(token[:duration])
          @original_base_note   = token[:base_note]
          @original_named_chord = token[:named_chord]
          @named_chord          = @original_named_chord.downcase
          @original_inversions  = token[:inversions]
          @base_note            = base_note
          @original_attack      = token[:attack]
          @original_decay       = token[:decay]
        end
      end

      def notes
        unless @notes
          build_chord_notes(@named_chord)
          build_inversions
        end
        @notes
      end

      def base_note
        @base_note || build_base_note(@original_base_note)
      end

      # Equality of two chords is given by the equality of all its notes, that is, their pitches.
      # See <tt>Note#==</tt>
      def ==(other)
        notes && notes == other.notes
      end

      def inversions
        build_inversions unless @inversions
        @inversions
      end

      def pivot_note
        build_inversions unless @pivot_note
        @pivot_note
      end

      def key_signature=(key_signature)
        @key_signature = key_signature
        if @base_note
          @base_note.key_signature = key_signature
          build_chord_notes(@named_chord)
          build_inversions
        end
        @notes.each{ |note| note.pattern = @pattern }
      end

      def substitute_variables!
        @base_note.pattern = @pattern
        build_chord_notes(@named_chord)
        build_inversions
      end

      private

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

        def build_chord_notes(named_chord)
          @named_chord = named_chord
          intervals   = CHORD_INTERVALS[@named_chord]
          @notes = [@base_note] + intervals.map{|interval| @base_note + interval}
        end

        def build_inversions
          # @original_inversions = original_inversions
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

    end

  end
end