module Stretto
  module MusicElements

    class Harmony < MusicElement

      attr_accessor :elements

      def initialize(original_string, options = {})
        @original_string = original_string
        @elements        = options[:original_elements]
      end

      def duration
        @elements.map(&:duration).max
      end

    end

  end
end