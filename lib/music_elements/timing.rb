require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Timing < MusicElement

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_value = options[:value]
      end

      def value=(value)
        @value = value
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