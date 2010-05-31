module Stretto
  module MusicElements

    class Note

      VALUES = { 'C' => 0,
                 'D' => 2,
                 'E' => 4,
                 'F' => 5,
                 'G' => 7,
                 'A' => 9,
                 'B' => 11 }

      ACCIDENTALS = { 'bb' => -2,
                      'b'  => -1,
                      '#'  =>  1,
                      '##' =>  2 }

      DURATIONS = {
                    'w' => 1.0,
                    'h' => 1.0 / 2,
                    'q' => 1.0 / 4,
                    'i' => 1.0 / 8,
                    's' => 1.0 / 16,
                    't' => 1.0 / 32,
                    'x' => 1.0 / 64,
                    'o' => 1.0 / 128 }

      attr_reader :original_string, :original_key, :original_accidental, :original_duration, :original_octave

      def initialize(original_string, options = {})
        @original_string    = original_string
        @original_key       = options[:original_key]
        @original_duration  = options[:original_duration]
        @accidental         = options[:original_accidental]
        @original_octave    = options[:original_octave]
      end

      def value
        calculate_value_from_key_and_octave
      end

      def duration
        calculate_duration
      end

      def octave
        calculate_octave
      end

      private

      def calculate_value_from_key_and_octave
        value = VALUES[@original_key]
        value += (calculate_octave * 12)
        value += calculate_accidental
        value
      end

      def calculate_accidental
        ACCIDENTALS[@accidental] || 0
      end

      def calculate_octave
        (@original_octave || 5).to_i
      end

      def calculate_duration
        DURATIONS[@original_duration]
      end
      
    end
    
  end
end