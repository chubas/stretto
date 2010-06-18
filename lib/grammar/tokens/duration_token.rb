module Stretto
  module Tokens
    class DurationToken < Treetop::Runtime::SyntaxNode

      def start_tie?
        _start_tie
      end

      def end_tie?
        _end_tie
      end

      def tuplet
        if duration_string.tuplet
          {:numerator   => duration_string.tuplet.numerator,
           :denominator => duration_string.tuplet.denominator}
        end
      end

      def duration_character
        duration_string.duration_character
      end

      def decimal_value
        duration_string.decimal_value.text_value if duration_string.decimal_value and duration_string.decimal_value.text_value.present?
      end

      def dots
        duration_string.dots
      end

    end
  end
end