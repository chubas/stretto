#require 'grammar/stretto_syntax'
require 'parsers/exceptions'

Treetop.load File.join(File.dirname(__FILE__), "../grammar/stretto_syntax")

module Stretto
  class Parser

    attr_accessor :parser, :parsed_elements

    def initialize(music_string)
      @music_string = music_string
      @parser       =  StrettoSyntaxParser.new
    end

    def to_stretto
      @parser.parse(@music_string).to_stretto
    end

  end
end