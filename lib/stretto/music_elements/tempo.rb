require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Tempo represents the bpm of the song.
    #
    # It is indicated by a +T+ followed by the value of the tempo.
    # There are some predefined variables that define the most common tempos
    # (see {Variables::TEMPO_VARIABLES}), and the default is _allegro_, that is,
    # a tempo of +T120+ bpm
    class Tempo < MusicElement

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_tempo!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_value = token[:value]
      end

      def value=(value)
         @value = value
      end

      def bpm
        value
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      def substitute_variables!
        self.value = value
      end

      def play(player)
        player.bpm = bpm
      end

    end

  end
end
