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

    module WithNoteStringToken
      def octave
        note_string.octave
      end

      def accidental
        note_string.accidental
      end

      def key
        note_string.key
      end

      def value
        note_string.value
      end
    end

  end
end