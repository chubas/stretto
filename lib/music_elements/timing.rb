require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Timing < MusicElement

      def initialize(token, pattern = nil)
        super(token[:text_value], :pattern => pattern)
        @original_value = token[:value]
      end

      def value=(value)
        @value = value
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      def substitute_variables!
        self.value = value
      end

    end

  end
end