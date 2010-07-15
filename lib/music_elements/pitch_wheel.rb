require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class PitchWheel < MusicElement

      MAX_PITCH_WHEEL_VALUE = 16383

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_pitch_wheel!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @original_value = token[:value]
      end

      def value=(value)
        if value < 0 or value > MAX_PITCH_WHEEL_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Pitch wheel should be in range 0..#{MAX_PITCH_WHEEL_VALUE}")
        end
        @value = value
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      def substitute_variables!
        self.value = value
      end

    end

  end
end