require File.join(File.dirname(__FILE__), '../../music_elements/key_signature')

module Stretto
  module Tokens

    # Token result from parsing a key signature
    #
    # @example "KGmaj"
    class KeySignatureToken < HashToken

      # @return [MusicElements::KeySignature] The constructed token
      def to_stretto(pattern = nil)
        Stretto::MusicElements::KeySignature.new(self, pattern)
      end

      # @return A string with the key
      # @example "C#"
      def key
        __note_key.text_value
      end

      # @return ['maj', 'min'] The scale of the key signature
      def scale
        __scale.text_value
      end

    end

  end
end