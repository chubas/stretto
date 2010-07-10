require File.join(File.dirname(__FILE__), '/../../music_elements/harmonic_chord')

module Stretto
  module Tokens
    class HarmonicChordToken < Treetop::Runtime::SyntaxNode

      def to_stretto(pattern = nil)
        Stretto::MusicElements::HarmonicChord.new(
            text_value,
            :original_base_notes  => base_notes(pattern),
            :pattern              => pattern
        )
      end

      def base_notes(pattern)
        [_first_element.to_stretto(pattern)] + _other_elements.elements.map{|element| element._element.to_stretto(pattern)}
      end

    end
  end
end