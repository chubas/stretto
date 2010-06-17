module Stretto
  module MusicElements
    module Duration

      DURATIONS = { 'w' => 1.0,
                    'h' => 1.0 / 2,
                    'q' => 1.0 / 4,
                    'i' => 1.0 / 8,
                    's' => 1.0 / 16,
                    't' => 1.0 / 32,
                    'x' => 1.0 / 64,
                    'o' => 1.0 / 128 }

      DEFAULT_DURATION = DURATIONS['q']

      def parse_duration(duration_token, default_duration = DEFAULT_DURATION)
        duration = case
          when !duration_token
            default_duration
          when duration_token.decimal_value
            duration_token.decimal_value.to_f
          when duration_token.duration_character
            DURATIONS[duration_token.duration_character]
        end
        if duration_token
          duration_token.dots.times{ duration *= 1.5 }
        end
        duration
      end

    end

  end
end