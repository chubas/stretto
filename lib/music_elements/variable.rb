require File.join(File.dirname(__FILE__), 'music_element')


module Stretto
  module MusicElements

    class Variable < MusicElement

      attr_reader :name, :value

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_variable!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @value = token[:value]
        @name  = token[:name]
      end

      def to_i
        @value.to_i(@pattern)
      end

      def to_f
        @value.to_f(@pattern)
      end

    end

  end
end