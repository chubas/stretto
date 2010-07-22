require File.join(File.dirname(__FILE__), '../../music_elements/polyphonic_pressure')

module Stretto
  module Tokens

    # Token from parsing a polyphonic pressure element
    #
    # @example "*80,100"
    class PolyphonicPressureToken < HashToken

      # @return [MusicElements::PolyphonicPressure] The PolyphonicPressure element constructed
      def to_stretto(pattern = nil)
        Stretto::MusicElements::PolyphonicPressure.new(self, pattern)
      end

      # @return [Value] Value of the pitch to apply pressure
      def pitch
        Stretto::Value.new(__pitch.wrap)
      end

      # @return [Value] Value of the pressure applied
      def value
        Stretto::Value.new(__value.wrap)
      end

    end
  end
end