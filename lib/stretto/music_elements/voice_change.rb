require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class VoiceChange < MusicElement

      MAX_VOICES = 15

      attr_reader :index

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_voice_change!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_value = token[:value]
      end

      def index
        @index || @original_value.to_i(pattern)
      end

      def index=(index)
        if index < 0 or index > MAX_VOICES
          raise Exceptions::ValueOutOfBoundsException.new("Voice value should be in range 0..#{MAX_VOICES}")
        end
        @index = index
      end

      def substitute_variables!
        self.index = index
      end

    end

  end
end
