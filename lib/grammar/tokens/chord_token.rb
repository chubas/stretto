require File.join(File.dirname(__FILE__), '../music_elements/chord')

module Stretto
  module Tokens
    class ChordToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::Chord.new(text_value)
      end

    end
  end
end