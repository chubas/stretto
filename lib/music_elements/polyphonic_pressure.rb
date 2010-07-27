require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Polyphonic pressure is similar to channel pressure (see {ChannelPressure}) but
    # it is applied to only a note. A polyphonic pressure token is specified by the notation
    # +*+_key_,_value_, where key is the value for the pitch (0 to 127) and value is the
    # applied pressure (0 to 127)
    class PolyphonicPressure < MusicElement

      MAX_PITCH_VALUE = 127
      MAX_VALUE       = 127

      attr_reader :pitch, :value

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_polyphonic_pressure!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_pitch = token[:pitch]
        @original_value = token[:value]
      end

      def pitch
        @pitch || @original_pitch.to_i(@pattern)
      end

      # Sets value and validates in range
      def pitch=(pitch)
        if pitch < 0 or pitch > MAX_PITCH_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Pitch value for polyphonic pressure should be in range 0..#{MAX_PITCH_VALUE}")
        end
        @pitch = pitch
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      # Sets value and validates in range
      def value=(value)
        if value < 0 or value > MAX_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Value for polyphonic pressure should be in range 0..#{MAX_VALUE}")
        end
        @value = value
      end

      private

        # @private
        def substitute_variables!
          self.pitch = pitch
          self.value = value
        end

    end

  end
end