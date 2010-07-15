module Stretto
  class TempoParser

    def self.parse!(music_string)
      TempoGrammarParser.new.parse(music_string) ||
          raise(Exceptions::ParseError.new("Invalid tempo string: #{music_string}"))
    end

  end
end