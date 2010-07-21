require File.join(File.dirname(__FILE__), '/../../music_elements/harmonic_chord')

module Stretto
  module Tokens
    class HarmonicChordToken < HashToken

      def to_stretto(pattern = nil)
        @pattern = pattern
        Stretto::MusicElements::HarmonicChord.new(self, pattern)
      end

      def notes
        [_first_element.to_stretto(@pattern)] + _other_elements.elements.map{|element| element._element.to_stretto(@pattern)}
      end

    end
  end
end