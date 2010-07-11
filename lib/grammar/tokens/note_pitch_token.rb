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
  end
end