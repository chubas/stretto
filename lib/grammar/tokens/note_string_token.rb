module Stretto
  module Tokens

    # TODO: Remove from Tokens Section, or create a new file now that NoteStringToken has disappeared

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

      # Optimize: Validates only accepts Stretto::Value
      def value
        note_string.value
      end
    end

  end
end