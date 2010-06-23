require File.join(File.dirname(__FILE__), '/../../music_elements/harmonic_chord')

module Stretto
  module Tokens
    class HarmonicChordToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::HarmonicChord.new(text_value,
          :original_base_notes => base_notes
        )
      end

      def base_notes
        [_first_element.to_stretto] + _other_elements.elements.map{|element| element._element.to_stretto}
      end

    end
  end
end