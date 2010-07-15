require File.join(File.dirname(__FILE__), '../../music_elements/polyphonic_pressure')

module Stretto
  module Tokens
    class PolyphonicPressureToken < HashToken

      def to_stretto(pattern = nil)
        Stretto::MusicElements::PolyphonicPressure.new(self, pattern)
      end

      def pitch
        Stretto::Value.new(__pitch.wrap)
      end

      def value
        Stretto::Value.new(__value.wrap)
      end

    end
  end
end