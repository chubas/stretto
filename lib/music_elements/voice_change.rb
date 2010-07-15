require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class VoiceChange < MusicElement

      MAX_VOICES = 15

      attr_reader :index

      def initialize(token, pattern = nil)
        super(token[:text_value], :pattern => pattern)
        @original_value = token[:value]

        # TODO: As voice is inherent to a pattern, raise an error if @pattern is nil
        self.index = @original_value.to_i(@pattern)
      end

      def index=(index)
        if index < 0 or index > MAX_VOICES
          raise Exceptions::ValueOutOfBoundsException.new("Voice value should be in range 0..#{MAX_VOICES}")
        end
        @index = index
      end
      
    end

  end
end