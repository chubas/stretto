require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class PitchWheel < MusicElement

      MAX_PITCH_WHEEL_VALUE = 16383

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_value = options[:value]
      end

      def value=(value)
        if value < 0 or value > MAX_PITCH_WHEEL_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Pitch wheel should be in range 0..#{MAX_PITCH_WHEEL_VALUE}")
        end
        @value = value
      end

      def value
        @original_value.to_i(@pattern)
      end

      def substitute_variables!
        self.value = value
      end

    end

  end
end