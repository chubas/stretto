module Stretto
  module Tokens
    module NoteKeyOctaveAndAccidentalToken

      def key
        note_key.key.text_value
      end

      def accidental
        note_key.accidental.text_value if note_key.accidental and note_key.accidental.text_value.present?
      end

      def value
        Stretto::Value.nil_value
      end

      def octave
        _octave.text_value if _octave and _octave.text_value.present?
      end

    end
  end
end