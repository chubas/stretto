module Stretto
  module Tokens


    # Token from parsing a note pitch, when an explicit pitch is given.
    #
    # @example "[60]". "[SOME_NOTE]"
    module NotePitchToken

      # Always return nil
      # @return nil
      def accidental
        nil
      end

      # Always return nil
      # @return nil
      def octave
        nil
      end

      # Always return nil
      # @return nil
      def key
        nil
      end

      # Wraps the value into a Value object, either a numeric or a variable value
      # @return [Value] The wrapped value for the pitch
      def pitch
        klass = if _pitch.is_numeric?
          Value::NumericValue
        else
          Value::VariableValue
        end
        Value.new(klass.new(_pitch.text_value))
      end
    end

    #------------------------------------------------------------------

    # Token result from parsing the part of a note that contains key, and optional
    # accidental and octave values
    #
    # @example "C#7"
    module NoteKeyAccidentalOctaveToken

      # @return [String] The key of the note ('A' through 'G')
      # @example "C"
      def key
        note_key.key.text_value
      end

      # @return [String, nil] The accidental of the note, if present (one of 'bb', 'b', 'n', '#', '##')
      # @example "#"
      def accidental
        note_key.accidental.text_value if note_key.accidental and note_key.accidental.text_value.present?
      end

      # Always return nil, as this is used to differentiate a note with a given pitch from one with key,
      # octave and accidental whose pitch has to be calculated
      # @return [nil]
      def pitch
        nil
      end

      # @return [String, nil] The octave of the note, if present
      # @example "5"
      def octave
        _octave.text_value if _octave and _octave.text_value.present?
      end
    end

    #------------------------------------------------------------------

    # Include this module to include note string functionality, that is, to provide
    # key, accidental, octave and/or pitch
    module WithNoteStringToken

      # @return (see NoteKeyAccidentalOctaveToken#octave)
      # @return (see NotePitchToken#octave)
      def octave
        note_string.octave
      end

      # @return (see NoteKeyAccidentalOctaveToken#accidental)
      # @return (see NotePitchToken#accidental)
      def accidental
        note_string.accidental
      end

      # @return (see NoteKeyAccidentalOctaveToken#key)
      # @return (see NotePitchToken#key)
      def key
        note_string.key
      end

      # @return (see NoteKeyAccidentalOctaveToken#pitch)
      # @return (see NotePitchToken#pitch)
      def pitch
        note_string.pitch
      end
    end

  end
end