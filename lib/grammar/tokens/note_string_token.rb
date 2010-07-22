module Stretto
  module Tokens


    module NotePitchToken

      def accidental
        nil
      end

      def octave
        nil
      end

      def key
        nil
      end

      def pitch
        klass = if _pitch.is_numeric?
          Stretto::Value::NumericValue
        else
          Stretto::Value::VariableValue
        end
        Stretto::Value.new(klass.new(_pitch.text_value))
      end
    end

    #------------------------------------------------------------------

    module NoteKeyAccidentalOctaveToken

      def key
        note_key.key.text_value
      end

      def accidental
        note_key.accidental.text_value if note_key.accidental and note_key.accidental.text_value.present?
      end

      def pitch
        nil
      end

      def octave
        _octave.text_value if _octave and _octave.text_value.present?
      end
    end

    #------------------------------------------------------------------

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
      def pitch
        note_string.pitch
      end
    end

  end
end