module Stretto
  module Tokens

    # Subclass of a parser token that overrides the #[] method to act like a Hash
    class HashToken < Treetop::Runtime::SyntaxNode

      # Quack like a hash. This is to make the individual element constructor accept either a hash
      # or a token
      def [](key)
        send(key)
      end

    end
  end
end