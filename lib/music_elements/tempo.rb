require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Tempo < MusicElement

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::TempoParser.parse!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @original_value = token[:value]
      end

      def value=(value)
         @value = value
      end

      def bpm
        value
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      def substitute_variables!
        self.value = value
      end

    end

  end
end