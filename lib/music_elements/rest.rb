require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements
    class Rest < MusicElement

      include Duration

      attr_reader :original_duration

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_rest!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        build_duration_from_token(token[:duration])
      end

    end
  end
end