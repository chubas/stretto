require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Represent an instrument change by the MIDI specification.
    #
    # The sound played depends on the soundbank installed by
    # the synthesizer, the MIDI standard defines 128 standard instruments
    # (see {Variables::INSTRUMENT_VARIABLES}) that are reflected by
    # JFugue with predefined variables.
    class Instrument < MusicElement

      MAX_INSTRUMENT_VALUE = 127

      # Returns an instrument with value 0 (piano)
      def self.default_instrument(pattern = nil)
        params = {
          :text_value => '',
          :value => Value.new(Value::NumericValue.new(0))
        }
        new(params, pattern)
      end

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_instrument!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern )
        @original_value = token[:value]
      end

      # Sets and validates value (0...127)
      def value=(value)
        if value < 0 or value > MAX_INSTRUMENT_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Instrument value should be in range 0..#{MAX_INSTRUMENT_VALUE}")
        end
        @value = value
      end

      # @return [Number] Returns or calculates the value for the
      #   instrument
      def value
        @value || @original_value.to_i(@pattern)
      end

      private
      
        def substitute_variables!
          self.value = value
        end

    end

  end
end