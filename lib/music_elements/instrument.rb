require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Instrument < MusicElement

      attr_reader :value

      def initialize(original_string, options = {})
        @original_string = original_string
        self.value = options[:original_value].to_i
      end

      def value=(value)
        if value < 0 or value > 127
          raise Exceptions::ValueOutOfBoundsException.new("Instrument value should be in range 0..127")
        end
        @value = value
      end

    end

  end
end