require File.join(File.dirname(__FILE__), '../../music_elements/key_signature')

module Stretto
  module Tokens

    class KeySignatureToken < HashToken

      def to_stretto(pattern = nil)
        Stretto::MusicElements::KeySignature.new(self, pattern)
      end

      def key
        __note_key.text_value
      end

      def scale
        __scale.text_value
      end

    end

  end
end