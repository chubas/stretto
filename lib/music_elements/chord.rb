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

      attr_reader :notes, :base_note
      attr_reader :inversions, :pivot_note
      attr_reader :original_duration, :duration
      attr_reader :named_chord
      attr_reader :key_signature

      extend Forwardable
      def_delegators :@base_note, :original_accidental, :accidental,
                                  :original_value,      :value,
                                  :original_key,        :key,
                                  :original_octave,     :octave,
                                  :original_attack,     :attack,
                                  :original_decay,      :decay

      def initialize(original_string, options = {})
        super(original_string, options)
        build_duration_from_token(options[:original_duration_token])
        build_base_note(options[:base_note])
        build_chord_notes(options[:named_chord])
        build_inversions(options[:original_inversions])
      end

      # Equality of two chords is given by the equality of all its notes, that is, their pitches.
      # See <tt>Note#==</tt>
      def ==(other)
        @notes == other.notes
      end

      def key_signature=(key_signature)
        @key_signature = key_signature
        if @base_note
          @base_note.key_signature = key_signature
          build_chord_notes(@named_chord)
          build_inversions(@original_inversions)
        end
      end

      private

        def build_base_note(base_note_options)
          base_note_options = base_note_options
          @base_note = Note.new(
              base_note_options[:original_string],
              :original_octave          => base_note_options[:original_octave] || DEFAULT_OCTAVE,
              :original_accidental      => base_note_options[:original_accidental],
              :original_key             => base_note_options[:original_key],
              :original_value           => base_note_options[:original_value],
              :original_duration_token  => @original_duration_token,
              :original_attack          => base_note_options[:original_attack],
              :original_decay           => base_note_options[:original_decay]
          )
        end

        def build_chord_notes(named_chord)
          @named_chord = named_chord
          intervals   = CHORD_INTERVALS[@named_chord]
          @notes = [@base_note] + intervals.map{|interval| @base_note + interval}
        end

        def build_inversions(original_inversions)
          @original_inversions  = original_inversions
          if @original_inversions
            @inversions = @original_inversions[:inversions]
            pivot_note  = @original_inversions[:pivot_note]
            @pivot_note = Note.new(
                pivot_note.text_value,
                :original_key             => pivot_note.key,
                :original_value           => pivot_note.value,
                :original_accidental      => pivot_note.accidental,
                :original_octave          => pivot_note.octave || DEFAULT_OCTAVE,
                :original_duration_token  => @original_duration_token
            ) if pivot_note
          else
            @inversions = 0
          end
          raise Exceptions::ChordInversionsException if @inversions >= @notes.size

          if @pivot_note
            actual_pivot = @notes.index{|note| note.value == @pivot_note.value}
            raise Exceptions::ChordInversionsException.new("Note #{@pivot_note.original_string}(#{@pivot_note.value}) does not belong to chord #{@original_string}") unless actual_pivot
            actual_pivot.times do
              @notes << @notes.shift + 12
            end
          else
            @inversions.times do
              @notes << @notes.shift + 12
            end
          end
        end

    end

  end
end