module Stretto
  module Tokens

    # Token result from parsing a duration
    #
    # @example "wh", "q*3:4", "/2.5"
    class DurationToken < Treetop::Runtime::SyntaxNode

      # @return [true, false] if the duration starts a tie (e.g., "w-")
      def start_of_tie?
        _start_of_tie.text_value.present? if _start_of_tie
      end

      # @return [true, false] if the duration ends a tie (e.g., "-w")
      def end_of_tie?
        _end_of_tie.text_value.present? if _end_of_tie
      end

      # @return [Hash, nil] A hash containing both the numerator and denominator, if present
      # @example { :numerator => 2, :denominator => 3 }
      def tuplet
        if duration_string.tuplet
          {:numerator   => duration_string.tuplet.numerator,
           :denominator => duration_string.tuplet.denominator}
        end
      end

      # @return [String] The duration expressed as characters
      # @example "h", "wq"
      def duration_character
        duration_string.duration_character
      end

      # @return [Value, nil] A value wrapping the value of the duration, if present
      def value
        Stretto::Value.new(duration_string.value.wrap) if duration_string.value
      end

      # @return [String] Returns a string with the number of dots in the duration
      # @example 2 (for string Cmajh..
      def dots
        duration_string.dots
      end

    end

    # Include this module to obtain functionality for duration token
    module WithDurationToken
      def duration
        __duration if __duration and __duration.text_value.present?
      end
    end

  end
end