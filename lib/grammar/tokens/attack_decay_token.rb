module Stretto
  module Tokens
    class AttackDecayToken < Treetop::Runtime::SyntaxNode

      # Returns a NumericToken, VariableToken or nil
      def attack
        _attack.value.wrap if _attack and _attack.text_value.present?
      end

      # Returns a NumericToken, VariableToken or nil
      def decay
        _decay.value.wrap if _decay and _decay.text_value.present?
      end

    end
  end

  module WithAttackDecayToken

    # Returns a Stretto::Value holding a Numeric Token, Variable Token, or nil
    def attack
      attack = attack_and_decay.attack
      Stretto::Value.new(attack)
    end

    # Returns a Stretto::Value holding a Numeric Token, Variable Token, or nil
    def decay
      decay = attack_and_decay.decay
      Stretto::Value.new(decay)
    end
  end
end