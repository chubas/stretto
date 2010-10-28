require File.join(File.dirname(__FILE__), '/../../music_elements/harmonic_chord')

module Stretto
  module Tokens

    # Token result from parsing a duration
    #
    # @example "C+D+E"
    class HarmonicChordToken < HashToken

      # @return [MusicElements::HarmonicChord] The constructed HarmonicChord element
      def to_stretto(pattern = nil)
        @pattern = pattern
        Stretto::MusicElements::HarmonicChord.new(self, pattern)
      end

      # @return [Array<MusicElement>] The notes that form this chord
      def notes
        [_first_element.to_stretto(@pattern)] +
            _other_elements.elements.map{|element| element._element.to_stretto(@pattern)}
      end

    end
  end
end