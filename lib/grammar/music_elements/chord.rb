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

      attr_accessor :notes, :base_note, :inversions

      def initialize(original_string, options = {})
        @original_string      = original_string
        build_notes(options)
        build_inversions(options)
      end

      private

        def build_notes(options)
          base_note = options[:base_note]
          @base_note = Note.new(
              base_note[:original_string],
              :original_octave      => base_note[:original_octave],
              :original_accidental  => base_note[:original_accidental],
              :original_key         => base_note[:original_key]
          )

          named_chord = options[:named_chord]
          intervals   = CHORD_INTERVALS[named_chord]
          @notes = intervals.map{|interval| @base_note + interval}
        end

        def build_inversions(options)
          @original_inversions  = options[:original_inversions]
          if @original_inversions
            @inversions = @original_inversions[:inversions]
            @pivot_note = @original_inversions[:pivot_note]
          else
            @inversions = 0
          end
          raise Exceptions::ChordInversionsException if @inversions >= @notes.size 
        end

    end

  end
end