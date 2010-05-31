#require 'grammar/stretto_syntax'
require File.join(File.dirname(__FILE__), '/exceptions')

Treetop.load File.join(File.dirname(__FILE__), "../grammar/stretto_syntax")

module Stretto
  class Parser

    attr_accessor :parser, :parsed_elements

    def initialize(music_string)
      @music_string = music_string
      @parser       =  StrettoSyntaxParser.new
    end

    def to_stretto
      parsed_string.to_stretto
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