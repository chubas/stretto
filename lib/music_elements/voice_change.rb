require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class VoiceChange < MusicElement

      MAX_VOICES = 15

      attr_reader :index

      def initialize(original_string, options = {})
        super(original_string, options)
        self.index = options[:original_value].to_i
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