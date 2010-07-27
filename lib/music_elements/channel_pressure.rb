require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # ChannelPressure sends a MIDI message similar to applying pressure to an
    # electronic keyboard. This event applies pressure to the whole channel, and its
    # value can rango from 0 to 127
    class ChannelPressure < MusicElement

      MAX_CHANNEL_PRESSURE_VALUE = 127

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_channel_pressure!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_value = token[:value]
      end

      # Sets value and validates in range
      def value=(value)
        if value < 0 or value > MAX_CHANNEL_PRESSURE_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Channel pressure should be in range 0..#{MAX_CHANNEL_PRESSURE_VALUE}")
        end
        @value = value
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      private

        # @private
        def substitute_variables!
          self.value = value
        end

    end

  end
end