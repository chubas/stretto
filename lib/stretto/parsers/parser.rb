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
      result = parsed_string.to_stretto(pattern)
      result.each_with_index do |e, i|
        e.next = result[i+1]
        e.prev = result[i-1] unless i-1 < 0
      end
      result
    end

    def valid?
      not parsed_string.nil?
    end

    def error_on
      @last_error_on
    end

    private

      def parsed_string
        parsed_string = @parser.parse(@music_string)
        if parsed_string
          @last_error_on = nil
        else
          @last_error_on = @parser.max_terminal_failure_index
        end
        parsed_string
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
        :harmony              => HarmonyGrammarParser,
        :harmonic_chord       => HarmonicChordGrammarParser,
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
        :variable             => VariableGrammarParser,
        :voice_change         => VoiceChangeGrammarParser
      }
      elements.each do |element, klass|
        define_method "parse_#{element}!" do |music_element|
          parse_music_element!(klass, music_element, element.to_s.gsub('_', ' '))
        end
      end

      def parse_element!(element, klass)
        send(:"parse_#{elementize(klass)}!", element)
      end

      def elementize(str)
        str.to_s.split('::').last.
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end

    end

  end
end
