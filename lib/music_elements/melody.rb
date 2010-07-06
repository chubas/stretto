require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Melody < MusicElement

      attr_reader :elements

      def initialize(original_string, options = {})
        super(original_string, options)
        @elements = options[:original_elements]
      end

      def duration
        @elements.map(&:duration).sum
      end

    end

  end
end