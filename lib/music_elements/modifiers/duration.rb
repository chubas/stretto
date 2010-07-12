module Stretto
  module MusicElements
    module Duration

      DURATIONS = { 'w' => Rational(1),
                    'h' => Rational(1, 2),
                    'q' => Rational(1, 4),
                    'i' => Rational(1, 8),
                    's' => Rational(1, 16),
                    't' => Rational(1, 32),
                    'x' => Rational(1, 64),
                    'o' => Rational(1, 128) }

      DEFAULT_DURATION = DURATIONS['q']
      DEFAULT_TUPLET_NUMERATOR    = 3
      DEFAULT_TUPLET_DENOMINATOR  = 2

      attr_reader :original_duration
      attr_reader :start_tie, :end_tie

      #-
      # param duration_token should be a DurationToken element
      # TODO: Make duration receive Stretto::Value(nil) instead of nil
      def build_duration_from_token(duration_token, default_duration = DEFAULT_DURATION)
        @original_duration_token = duration_token
        @original_duration       = duration_token ? duration_token.text_value : ''
        @processed_value         = Duration.parse_duration(@original_duration_token, default_duration)
        build_ties
      end

      def duration
        case @processed_value
          when Stretto::Value then @processed_value.to_f(@pattern)
          else @processed_value
        end
      end

      def start_of_tie?
        @start_of_tie.present?
      end

      def end_of_tie?
        @end_of_tie.present?
      end

      def build_ties
        @start_of_tie = @original_duration_token.start_of_tie? if @original_duration_token
        @end_of_tie   = @original_duration_token.end_of_tie?   if @original_duration_token
      end

      def tied_elements
        current = self
        elements = [current]
        while next_is_tied?(current)
          current = current.next
          elements << current unless current.kind_of?(Measure)
        end
        elements
      end

      def tied_duration
        tied_elements.inject(0){|sum, element| sum + element.duration}
      end

      # TODO: Big else case. Refactor
      def self.parse_duration(duration_token, default_duration = DEFAULT_DURATION)
        if !duration_token
          default_duration
        elsif duration_token.value
          duration_token.value
        else
          # It comes as a character + modifiers
          duration = duration_token.duration_character.split('').map do |char_duration| # TODO: deprecation. each_char is only 1.9+
            DURATIONS[char_duration.downcase]
          end.sum
          original_duration = duration
          duration_token.dots.times do |dot_duration|
            duration += (original_duration * Rational(1,  2 ** (dot_duration + 1)))
          end
          if duration_token.tuplet
            numerator = duration_token.tuplet[:numerator]     || DEFAULT_TUPLET_NUMERATOR
            denominator = duration_token.tuplet[:denominator] || DEFAULT_TUPLET_DENOMINATOR
            duration *= Rational(denominator.to_i, numerator.to_i)
          end
          duration
        end
      end

      private

        def next_is_tied?(note)
          note.start_of_tie?      &&
            note.next             &&
            note.next.end_of_tie? &&
            (note.class == note.next.class || note.next.kind_of?(Measure) || note.kind_of?(Measure))
        end

    end

  end
end