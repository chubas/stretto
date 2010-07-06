require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Measure < MusicElement

      def initialize(original_string, options = {})
        super(original_string, options)
      end

      def duration
        0
      end

      def tied_elements
        next_element = self.next
        if next_element
          next_element.tied_elements
        else
          []
        end
      end

      def tied_duration
        tied_elements.inject(0){|sum, element| sum + element.duration}
      end

    end

  end
end