require File.dirname(__FILE__) + '/exceptions'

Treetop.load File.join(File.dirname(__FILE__), "../grammar/stretto_grammar")

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

    class << self

      private
        def parse_music_element!(klass, music_string, expected_element)
          klass.new.parse(music_string) ||
              raise(Exceptions::ParseError.new("Invalid #{expected_element}: #{music_string}"))
        end

      public

      elements = {
        :channel_pressure     => ChannelPressureGrammarParser,
        :chord                => ChordGrammarParser,
        :controller_change    => ControllerChangeGrammarParser,
        :instrument           => InstrumentGrammarParser,
        :key_signature        => KeySignatureGrammarParser,
        :layer_change         => LayerChangeGrammarParser,
        :measure              => MeasureGrammarParser,
        :note                 => NoteGrammarParser,
        :pitch_wheel          => PitchWheelGrammarParser,
        :polyphonic_pressure  => PolyphonicPressureGrammarParser,
        :rest                 => RestGrammarParser,
        :timing               => TimingGrammarParser,
        :tempo                => TempoGrammarParser,
        :variable             => VariableGrammarParser
      }
      elements.each do |element, klass|
        define_method "parse_#{element}!" do |music_element|
          parse_music_element!(klass, music_element, element.to_s.gsub('_', ' '))
        end
      end

    end

  end
end
