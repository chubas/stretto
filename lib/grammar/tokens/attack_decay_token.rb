module Stretto
  module Tokens

    # Token result from parsing attack and decay syntax
    #
    # @example "a100d[VAR]"
    class AttackDecayToken < Treetop::Runtime::SyntaxNode

      # @return [NumericToken, VariableToken, nil]
      def attack
        _attack.value.wrap if _attack and _attack.text_value.present?
      end

      # @return [NumericToken, VariableToken, nil]
      def decay
        _decay.value.wrap if _decay and _decay.text_value.present?
      end

    end


    # Include this module to access functionality of attack and decay tokens
    #
    # @see #attack
    # @see #decay
    module WithAttackDecayToken

      # @return [Value, nil] The attack value wrapped by a Value object, or nil
      def attack
        attack = attack_and_decay.attack
        Stretto::Value.new(attack)
      end

      # @return [Value, nil] The decay value wrapped by a Value object, or nil
      def decay
        decay = attack_and_decay.decay
        Stretto::Value.new(decay)
      end
    end
  end

end