require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Does not have effect in the playback, it represents a measure
    # for readability of the music texts
    class Measure < MusicElement

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_measure!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
      end

      # @private
      # TODO: Make tests for other elements inside ties, move this to MusicElement
      def tied_elements
        next_element = self.next
        if next_element
          next_element.tied_elements
        else
          []
        end
      end

      # @private
      # TODO: Make tests for other elements inside ties, move this to MusicElement
      def tied_duration
        tied_elements.inject(0){|sum, element| sum + element.duration}
      end

    end

  end
end