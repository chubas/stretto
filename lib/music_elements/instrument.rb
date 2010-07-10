require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Instrument < MusicElement

      MAX_INSTRUMENT_VALUE = 127

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_value = options[:value]
      end

      def value=(value)
        if value < 0 or value > MAX_INSTRUMENT_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Instrument value should be in range 0..#{MAX_INSTRUMENT_VALUE}")
        end
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