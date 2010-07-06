require File.join(File.dirname(__FILE__), '../util/node')
require File.join(File.dirname(__FILE__), 'modifiers/duration')

module Stretto
  module MusicElements

    class MusicElement

      include Stretto::Node

      attr_reader :original_string

      def to_s
        original_string || build_music_string
      end

      def build_music_string
        raise "Not implemented"
      end

      alias inspect to_s

      def start_of_tie?
        true
      end

      def end_of_tie?
        true
      end

    end

  end
end