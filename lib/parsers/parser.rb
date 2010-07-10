require File.join(File.dirname(__FILE__), '/exceptions')

Treetop.load File.join(File.dirname(__FILE__), "../grammar/stretto_syntax")

module Stretto
  class Parser

    attr_reader :parser, :parsed_elements

    def initialize(music_string)
      @music_string = music_string
      @parser       = StrettoSyntaxParser.new
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
