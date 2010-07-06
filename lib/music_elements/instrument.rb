require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Instrument < MusicElement

      MAX_INSTRUMENT_VALUE = 127

      attr_reader :value

      def initialize(original_string, options = {})
        super(original_string, options)
        self.value = options[:original_value].to_i
      end

      def value=(value)
        if value < 0 or value > MAX_INSTRUMENT_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Instrument value should be in range 0..#{MAX_INSTRUMENT_VALUE}")
        end
        @value = value
      end

    end

  end
end