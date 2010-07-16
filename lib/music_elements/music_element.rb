require File.join(File.dirname(__FILE__), '../util/node')
require File.join(File.dirname(__FILE__), 'modifiers/duration')

module Stretto
  module MusicElements

    class MusicElement

      include Stretto::Node

      attr_reader :original_string
      attr_reader :pattern
      attr_accessor :instrument

      def initialize(original_string, options = {})
        @original_string = original_string
        @pattern = options[:pattern]
      end

      def to_s
        original_string || build_music_string
      end

      def build_music_string
        raise "build_music_string not implemented in #{self.class}"
      end

      alias inspect to_s

      def start_of_tie?
        true
      end

      def end_of_tie?
        true
      end

      def duration
        0
      end

      # TODO: Big TODO - Change this method's name for a callback.
      # This method should not exist. Element state should be independent of presence of @pattern, and
      # values that need a definite value of pattern should raise an error instead
      def substitute_variables!
      end

      def pattern=(pattern)
        @pattern = pattern
        substitute_variables! # TODO: Remove this call
      end

    end

  end
end