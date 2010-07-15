module Stretto
  class TimingParser

    def self.parse!(music_string)
      TimingGrammarParser.new.parse(music_string) ||
          raise(Exceptions::ParseError.new("Invalid timing string: #{music_string}"))
    end

  end
end