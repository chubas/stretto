require 'forwardable'

module Stretto
  module MusicElements

    class Chord

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

      attr_accessor :notes, :base_note
      attr_accessor :inversions, :pivot_note
      attr_accessor :original_duration, :duration
      attr_accessor :named_chord

      extend Forwardable
      def_delegators :@base_note, :original_accidental, :accidental,
                                  :original_value, :value,
                                  :original_key, :key

      def initialize(original_string, options = {})
        @original_string      = original_string
        build_duration(options)
        build_notes(options)
        build_inversions(options)
      end

      def build_duration(options)
        @original_duration_token = options[:original_duration_token]
        @original_duration = @original_duration_token.text_value if @original_duration_token
        @duration = Note::DURATIONS[@original_duration || Note::DEFAULT_DURATION] # TODO: Move this to a shared place
      end

      def octave
        @base_note.octave
      end

      private

        def build_notes(options)
          base_note_options = options[:base_note]
          @base_note = Note.new(
              base_note_options[:original_string],
              :original_octave          => base_note_options[:original_octave] || DEFAULT_OCTAVE,
              :original_accidental      => base_note_options[:original_accidental],
              :original_key             => base_note_options[:original_key],
              :original_value           => base_note_options[:original_value],
              :original_duration_token  => @original_duration_token
          )

          @named_chord = options[:named_chord]
          intervals   = CHORD_INTERVALS[@named_chord]
          @notes = [@base_note] + intervals.map{|interval| @base_note + interval}
        end

        def build_inversions(options)
          @original_inversions  = options[:original_inversions]
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