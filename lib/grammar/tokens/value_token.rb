module Stretto
  module Tokens

    module NumericToken
      def wrap
        Stretto::Value::NumericValue.new(text_value.to_f)
      end
    end

    module VariableToken
      def wrap
        Stretto::Value::VariableValue.new(name.text_value)
      end
    end

  end
end