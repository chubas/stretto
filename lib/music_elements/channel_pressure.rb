require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class ChannelPressure < MusicElement

      MAX_CHANNEL_PRESSURE_VALUE = 127

      attr_reader :value

      def initialize(original_string, options = {})
        @original_string = original_string
        self.value = options[:original_value].to_i
      end

      def value=(value)
        if value < 0 or value > MAX_CHANNEL_PRESSURE_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Channel pressure should be in range 0..#{MAX_CHANNEL_PRESSURE_VALUE}")
        end
        @value = value
      end

    end

  end
end