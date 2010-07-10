require File.join(File.dirname(__FILE__), '../../music_elements/polyphonic_pressure')

module Stretto
  module Tokens
    class PolyphonicPressureToken < Treetop::Runtime::SyntaxNode

      def to_stretto(pattern = nil)
        Stretto::MusicElements::PolyphonicPressure.new(
            text_value,
            :original_pitch => Stretto::Value.new(pitch.wrap),
            :original_value => Stretto::Value.new(value.wrap),
            :pattern        => pattern
        )
      end

    end
  end
end