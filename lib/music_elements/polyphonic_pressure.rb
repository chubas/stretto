require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class PolyphonicPressure < MusicElement

      MAX_PITCH_VALUE = 127
      MAX_VALUE       = 127

      attr_reader :pitch, :value

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_polyphonic_pressure!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @original_pitch = token[:pitch]
        @original_value = token[:value]
      end

      def pitch
        @pitch || @original_pitch.to_i(@pattern)
      end

      def pitch=(pitch)
        if pitch < 0 or pitch > MAX_PITCH_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Pitch value for polyphonic pressure should be in range 0..#{MAX_PITCH_VALUE}")
        end
        @pitch = pitch
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      def value=(value)
        if value < 0 or value > MAX_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Value for polyphonic pressure should be in range 0..#{MAX_VALUE}")
        end
        @value = value
      end

      def substitute_variables!
        self.pitch = pitch
        self.value = value
      end

    end

  end
end