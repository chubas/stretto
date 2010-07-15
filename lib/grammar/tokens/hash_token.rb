module Stretto
  module Tokens
    class HashToken < Treetop::Runtime::SyntaxNode

      def [](key)
        send(key)
      end

    end
  end
end