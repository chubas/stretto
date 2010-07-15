module Stretto
  class InstrumentParser

    def self.parse!(music_string)
      InstrumentGrammarParser.new.parse(music_string) ||
          raise(Exceptions::ParseError.new("Invalid instrument string: #{music_string}"))
    end

  end
end
