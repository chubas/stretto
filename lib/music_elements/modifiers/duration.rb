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

      attr_accessor :original_duration, :duration
      attr_accessor :start_tie, :end_tie

      def build_duration_from_token(duration_token, default_duration = DEFAULT_DURATION)
        @original_duration_token = duration_token
        @original_duration       = @original_duration_token.text_value if @original_duration_token
        @duration                = Duration.parse_duration(@original_duration_token, default_duration)
        build_ties
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
        while current.start_of_tie? && current.next && current.next.end_of_tie? && current.class == current.next.class
          elements << (current = current.next)
        end
        elements
      end

      def tied_duration
        tied_elements.map(&:duration).sum
      end
      
      def self.parse_duration(duration_token, default_duration = DEFAULT_DURATION)
        duration = case
          when !duration_token
            default_duration
          when duration_token.decimal_value
            duration_token.decimal_value.to_f
          when duration_token.duration_character
            duration_token.duration_character.split('').map do |char_duration| # TODO: deprecation. each_char is only 1.9+
              DURATIONS[char_duration]
            end.sum
        end
        if duration_token
          original_duration = duration
          duration_token.dots.times do |dot_duration|
            duration += (original_duration * Rational(1,  2 ** (dot_duration + 1)))  
          end


          if duration_token.tuplet
            numerator = duration_token.tuplet[:numerator]     || DEFAULT_TUPLET_NUMERATOR
            denominator = duration_token.tuplet[:denominator] || DEFAULT_TUPLET_DENOMINATOR
            duration *= Rational(denominator.to_i, numerator.to_i)
          end
        end
        duration
      end

    end

  end
end