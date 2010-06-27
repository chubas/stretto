require File.join(File.dirname(__FILE__), '../../music_elements/key_signature')

module Stretto
  module Tokens

    class KeySignatureToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::KeySignature.new(
            text_value,
            :original_key   => note_key.text_value,
            :original_scale => scale.text_value 
        )
      end

    end

  end
end