require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Harmony < MusicElement

      attr_accessor :elements

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_harmony!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @elements = token[:music_elements]
      end

      def duration
        @elements.map(&:duration).max
      end
      
      def pattern=(pattern)
        @elements.each { |element| element.pattern = pattern }
      end

    end

  end
end