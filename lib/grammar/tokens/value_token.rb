module Stretto
  module Tokens

    # Represents a numeric value (either decimal or integer) parsed from a music string
    # @example "10.5"
    # @see VariableToken
    module NumericToken

      # @return [Value::NumericValue] A NumericValue with the parsed text as a float number
      def wrap
        Stretto::Value::NumericValue.new(text_value.to_f)
      end
    end

    # Represents a variable value parsed from a music string
    # @example "[SOME_VARIABLE]"
    # @see NumericToken
    module VariableToken

      # @return [Value::VariableValue] A VariableValue with the parsed text as the name of
      #   the variable it references
      def wrap
        Stretto::Value::VariableValue.new(name.text_value)
      end
    end

  end
end