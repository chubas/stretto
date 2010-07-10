module Stretto
  module Tokens

    module NumericToken

      def wrap
        Stretto::Value::NumericValue.new(text_value.to_f)
      end

    end

  end
end