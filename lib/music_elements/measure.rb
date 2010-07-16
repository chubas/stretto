require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Measure < MusicElement

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_measure!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
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