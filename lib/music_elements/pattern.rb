require File.join(File.dirname(__FILE__), 'voice')

module Stretto

  # Composition is a series of MusicElements, that hold a context (like tied notes or key signature modifications)
  # Is the equivalent of the JFugue implementation <tt>Pattern</tt>.
  #-
  # NOTE: This class behavior is not definite, and may change during the development of Stretto
  # until the first stable version
  #+
  class Pattern < Array

    DEFAULT_VOICE_INDEX = 0

    attr_reader :voices

    def initialize(music_string = "")
      @parser           = Stretto::Parser.new(music_string)
      @current_voice    = Voice.new
      @voices           = { DEFAULT_VOICE_INDEX => @current_voice }
      @__key_signature  = nil
      @parser.to_stretto.each { |music_element| self << music_element }
      eliminate_mute_voices
    end

    def eliminate_mute_voices
      @voices.delete_if{|key, value| value.empty? }
    end

    def <<(other)
      if last
        last.next   = other
        other.prev  = last
      end
      other.key_signature = @__key_signature if other.respond_to?(:key_signature=)
      @__key_signature = other if other.kind_of?(MusicElements::KeySignature)

      if other.kind_of?(MusicElements::VoiceChange)
        @current_voice = (@voices[other.index] ||= Voice.new)
      else
        @current_voice << other
      end
      super(other)
    end

    def voice(index)
      @voices[index]
    end

  end
end