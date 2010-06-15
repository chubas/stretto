require File.join(File.dirname(__FILE__), '../music_elements/chord')

module Stretto
  module Tokens
    module NoteStringToken

      def octave
        super.text_value if super and super.text_value.present?
      end

      def accidental
        super.text_value if super and super.text_value.present?
      end

      def key
        super.text_value if super and super.text_value.present?
      end

      def value
        super.text_value if super and super.text_value.present?
      end

    end
  end
end