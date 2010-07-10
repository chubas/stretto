require File.join(File.dirname(__FILE__), 'voice')

module Stretto

  # Pattern is a series of MusicElements, that hold a context (like tied notes or key signature modifications)
  # Is the equivalent of the JFugue implementation <tt>Pattern</tt>.
  #-
  # NOTE: This class behavior is not definite, and may change during the development of Stretto
  # until the first stable version
  #+
  class Pattern < Array

    DEFAULT_VOICE_INDEX = 0

    attr_reader :voices, :variables # TODO: Limit access to variables

    def initialize(music_string = "")
      @parser           = Stretto::Parser.new(music_string)
      @voices           = { }
      @variables        = { }
      @__key_signature  = nil
      @parser.to_stretto(self).each { |music_element| self << music_element }
    end

    def elements
      to_a
    end

    def <<(other)
      other.pattern = self
      if last
        last.next   = other
        other.prev  = last
      end

      other.key_signature = @__key_signature if other.respond_to?(:key_signature=)
      @__key_signature = other if other.kind_of?(MusicElements::KeySignature)

      if other.kind_of?(MusicElements::VariableDefinition)
        @variables[other.name] = other.value
      end

      if other.kind_of?(MusicElements::VoiceChange)
        @current_voice = (@voices[other.index] ||= Voice.new)
      else
        @voices[DEFAULT_VOICE_INDEX] = @current_voice = Voice.new unless @current_voice
        @current_voice << other
      end
      super(other)
    end

    def voice(index)
      @voices[index]
    end

    def variable(name)
      @variables[name] || raise(Exceptions::VariableNotDefinedException.new("Variable '#{name}' not defined in pattern"))
    end

  end
end
