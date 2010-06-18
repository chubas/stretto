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

      def parse_duration(duration_token, default_duration = DEFAULT_DURATION)
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