module Stretto
  module Tokens
    class DurationToken < Treetop::Runtime::SyntaxNode

      def start_of_tie?
        _start_of_tie.text_value.present? if _start_of_tie
      end

      def end_of_tie?
        _end_of_tie.text_value.present? if _end_of_tie
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

      def value
        Stretto::Value.new(duration_string.value.wrap) if duration_string.value
      end

      def dots
        duration_string.dots
      end

    end

    module WithDurationToken
      def duration
        _duration if _duration and _duration.text_value.present?
      end
    end

  end
end