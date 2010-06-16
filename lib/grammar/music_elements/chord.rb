module Stretto
  module MusicElements

    class Chord

      CHORD_INTERVALS = {
        'maj'       => [0, 4, 7],
        'min'       => [0, 3, 7],
        'aug'       => [0, 4, 8],
        'dim'       => [0, 3, 6],
        'dom7'      => [0, 4, 7, 10],
        'maj7'      => [0, 4, 7, 11],
        'min7'      => [0, 3, 7, 10],
        'sus4'      => [0, 5, 7],
        'sus2'      => [0, 2, 7],
        'maj6'      => [0, 4, 7, 9],
        'min6'      => [0, 3, 7, 9],
        'dom9'      => [0, 4, 7, 10, 14],
        'maj9'      => [0, 4, 7, 11, 14],
        'min9'      => [0, 3, 7, 10, 14],
        'dim7'      => [0, 3, 6, 9],
        'add9'      => [0, 4, 7, 14],
        'min11'     => [0, 7, 10, 14, 15, 17],
        'dom11'     => [0, 7, 10, 14, 17],
        'dom13'     => [0, 7, 10, 14, 16, 21],
        'min13'     => [0, 7, 10, 14, 15, 21],
        'maj13'     => [0, 7, 11, 14, 16, 21],
        'dom7<5'    => [0, 4, 6, 10],
        'dom7>5'    => [0, 4, 8, 10],
        'maj7<5'    => [0, 4, 6, 11],
        'maj7>5'    => [0, 4, 8, 11],
        'minmaj7'   => [0, 3, 7, 11],
        'dom7<5<9'  => [0, 4, 6, 10, 13],
        'dom7<5>9'  => [0, 4, 6, 10, 15],
        'dom7>5<9'  => [0, 4, 8, 10, 13],
        'dom7>5>9'  => [0, 4, 8, 10, 15]
      }

      DEFAULT_OCTAVE = 3

      attr_accessor :notes, :inversions, :pivot_note
      attr_accessor :original_duration, :duration

      def initialize(original_string, options = {})
        @original_string      = original_string
        build_duration(options)
        build_notes(options)
        build_inversions(options)
      end

      def build_duration(options)
        @original_duration = options[:original_duration]
        @duration = Note::DURATIONS[@original_duration || 'q'] # TODO: Move this to a shared place
      end

      def base_note
        @notes.first
      end

      def octave
        base_note.octave
      end

      private

        def build_notes(options)
          base_note_options = options[:base_note]
          initial_base_note = Note.new(
              base_note_options[:original_string],
              :original_octave      => base_note_options[:original_octave] || DEFAULT_OCTAVE,
              :original_accidental  => base_note_options[:original_accidental],
              :original_key         => base_note_options[:original_key],
              :original_value       => base_note_options[:original_value],
              :original_duration    => @original_duration
          )

          named_chord = options[:named_chord]
          intervals   = CHORD_INTERVALS[named_chord]
          @notes = intervals.map{|interval| initial_base_note + interval}
        end

        def build_inversions(options)
          @original_inversions  = options[:original_inversions]
          if @original_inversions
            @inversions = @original_inversions[:inversions]
            pivot_note  = @original_inversions[:pivot_note]
            @pivot_note = Stretto::MusicElements::Note.new(
                pivot_note.text_value,
                :original_key         => pivot_note.key,
                :original_value       => pivot_note.value,
                :original_accidental  => pivot_note.accidental,
                :original_octave      => pivot_note.octave || DEFAULT_OCTAVE
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