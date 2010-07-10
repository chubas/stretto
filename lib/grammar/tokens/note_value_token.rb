module Stretto
  module Tokens
    module NoteValueToken

      def accidental
        nil
      end

      def octave
        nil
      end

      def key
        nil
      end

      def value
        klass = if _value.is_numeric?
          Stretto::Value::NumericValue
        else
          Stretto::Value::VariableValue
        end
        Stretto::Value.new(klass.new(_value.text_value))
      end

    end
  end
end