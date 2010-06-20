module Stretto
  module Tokens
    class AttackDecayToken < Treetop::Runtime::SyntaxNode

      def attack
        _attack.value.text_value if _attack and _attack.text_value.present?
      end

      def decay
        _decay.value.text_value if _decay and _decay.text_value.present?
      end

    end
  end

  module WithAttackDecayToken
    def attack
      attack_and_decay.attack
    end

    def decay
      attack_and_decay.decay
    end
  end
end