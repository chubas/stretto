require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Tempo < MusicElement

      attr_reader :value

      def initialize(original_string, options = {})
        @original_string = original_string
        self.value = options[:original_value].to_i
      end

      def value=(value)
         @value = value
      end

      def bpm
        @value
      end

    end

  end
end