require File.join(File.dirname(__FILE__), '../parsers/parser')

module Stretto

  # Composition is a series of MusicElements, that hold a context (like tied notes or key signature modifications)
  # Is the equivalent of the JFugue implementation <tt>Pattern</tt>.
  #-
  # NOTE: This class behavior is not definite, and may change during the development of Stretto
  # until the first stable version
  #+
  class Pattern < Array

    def initialize(music_string = "")
      @parser = Stretto::Parser.new(music_string)
      @__key_signature = nil
      @parser.to_stretto.each { |music_element| self << music_element }
    end

    def <<(other)
      if last
        last.next   = other
        other.prev  = last
      end
      other.key_signature = @__key_signature if other.respond_to?(:key_signature=)
      @__key_signature = other if other.kind_of?(MusicElements::KeySignature)
      super(other)
    end

  end
end