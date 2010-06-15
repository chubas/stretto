module Stretto
  module MusicElements
    class Rest

      DURATIONS = {
                    'w' => 1.0,
                    'h' => 1.0 / 2,
                    'q' => 1.0 / 4,
                    'i' => 1.0 / 8,
                    's' => 1.0 / 16,
                    't' => 1.0 / 32,
                    'x' => 1.0 / 64,
                    'o' => 1.0 / 128 } # TODO: Refactor this with notes and chords durations


      attr_reader :original_duration, :duration

      def initialize(options = {})
        @original_duration = options[:original_duration]
        @duration          = DURATIONS[@original_duration]
      end

    end
  end
end