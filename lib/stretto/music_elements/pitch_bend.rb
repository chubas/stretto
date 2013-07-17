require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Pitch bend, according to MIDI spacification, changes the tone of a note in steps of
    # hundredth of a note. The full range can go from 0 to 16383, being 8192 the middle pitch,
    # that is, no variation.
    #
    # Pitch bends are represented with a +&+ symbol before, for example +&16000+
    class PitchBend < MusicElement

      MAX_PITCH_BEND_VALUE = 16383

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_pitch_bend!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_value = token[:value]
      end

      # Sets value and validates it is in range
      def value=(value)
        if value < 0 or value > MAX_PITCH_BEND_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Pitch bend should be in range 0..#{MAX_PITCH_BEND_VALUE}")
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