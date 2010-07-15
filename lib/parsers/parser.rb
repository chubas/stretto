require File.dirname(__FILE__) + '/exceptions'

Treetop.load File.join(File.dirname(__FILE__), "../grammar/stretto_grammar")

require File.dirname(__FILE__) + '/instrument_parser'
require File.dirname(__FILE__) + '/tempo_parser'

module Stretto
  class Parser

    attr_reader :parser, :parsed_elements

    def initialize(music_string)
      @music_string = music_string
      @parser       = StrettoGrammarParser.new
    end

    def to_stretto(pattern = nil)
      parsed_string.to_stretto(pattern)
    end

    def valid?
      not parsed_string.nil?
    end

    private

      def parsed_string
        @parser.parse(@music_string)
      end

  end
end
