require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class PolyphonicPressure < MusicElement

      MAX_PITCH_VALUE = 127
      MAX_VALUE       = 127

      attr_reader :pitch, :value

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_pitch = options[:original_pitch]
        @original_value = options[:original_value]
      end

      def pitch
        @original_pitch.to_i(@pattern)
      end

      def pitch=(pitch)
        if pitch < 0 or pitch > MAX_PITCH_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Pitch value for polyphonic pressure should be in range 0..#{MAX_PITCH_VALUE}")
        end
        @pitch = pitch
      end

      def value
        @original_value.to_i(@pattern)
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