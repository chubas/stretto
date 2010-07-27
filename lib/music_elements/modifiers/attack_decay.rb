module Stretto
  module MusicElements

    # This module encapsulates behavior for all elements that specify attack and decay values
    #
    # Attack represents the "warm up" of the note, and decay its "cool down", that is, the
    # times it takes to the note to reach its main volume form 0 when building, and the
    # inverse when going into silence. The default value for both is 0
    module AttackDecay

      DEFAULT_ATTACK = 0
      DEFAULT_DECAY  = 0

      attr_reader :original_attack, :original_decay

      # Sets up the original attack and decay tokens
      def build_attack_and_decay(original_attack, original_decay)
        @original_attack = original_attack
        @original_decay  = original_decay
      end

      # Sets the instance variable `@attack` and performs validation in range
      #
      # @raise [Exceptions::InvalidValueException] if the value is greater than 127
      def attack=(attack)
        @attack = attack || DEFAULT_ATTACK
        if @attack < 0 or @attack > 127
          raise Exceptions::InvalidValueException.new("Attack should be in the range 0..127")
        end
      end

      # Sets the instance variable `@decay` and performs validation in range
      #
      # @raise [Exceptions::InvalidValueException] if the value is greater than 127
      def decay=(decay)
        @decay = decay || DEFAULT_DECAY
        if @decay < 0 or @decay > 127
          raise Exceptions::InvalidValueException.new("Decay should be in the range 0..127")
        end
      end

      # @return [Number] Numeric value for attack, or the default one
      def attack
        @original_attack.to_i(@pattern) || DEFAULT_ATTACK
      end

      # @return [Number] Numeric value for delay, or the default one
      def decay
        @original_decay.to_i(@pattern) || DEFAULT_DECAY
      end

    end

  end
end