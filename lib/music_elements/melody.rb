module Stretto
  module MusicElements

    class Melody < MusicElement

      def initialize(original_string, options = {})
        @original_string = original_string
        @elements = options[:original_elements]
      end

      def duration
        @elements.map(&:duration).sum
      end

    end

  end
end