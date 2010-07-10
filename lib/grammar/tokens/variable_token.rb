module Stretto
  module Tokens

    module VariableToken

      def wrap
        Stretto::Value::VariableValue.new(name.text_value)
      end

    end

  end
end