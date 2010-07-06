require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Harmony < MusicElement

      attr_accessor :elements

      def initialize(original_string, options = {})
        super(original_string, options)
        @elements        = options[:original_elements]
      end

      def duration
        @elements.map(&:duration).max
      end

    end

  end
end