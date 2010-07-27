module Stretto
  module MusicElements

    # This module encapsulates behavior for elements that specify a duration.
    #
    # Duration can modify notes, chords and rests. It is specified after the note string,
    # and its relative to the duration of the whole note (see {Tempo}). That means that a
    # duration of 1.0 represents a whole note, 0.5 a half note, and 1.5 a whole and a half
    # note, for instance.
    #
    # A duration may be indicated by the duration letters, or literally as a numeric
    # value.
    #
    # In the first way, the letter for the duration is indicated, with the following values:
    #
    # +whole+:: w
    # +half+:: h
    # +quarter+:: q
    # +eighth+:: i
    # +sixteenth+:: s
    # +thity-second+:: t
    # +sixty-fourth+:: x
    # +one-twenty-eighth+:: o
    #
    # The duration can be concatenated (so a duration of +hq+ qould be three quarters), and
    # you may append one or more dot modifiers, that add half the value of the note succesively
    # (see http://en.wikipedia.org/wiki/Dotted_note).
    #
    # Additionally, tuplets can be built by appending a tuplet notation, specified by the
    # syntax +*+_numerator_+:+_denominator_ (see http://en.wikipedia.org/wiki/Tuplet for more
    # information about tuplets). If omitter, the numerator and denominator will default to
    # 3 and 2, respectively (most commonly called a triplet).
    #
    # The other way to specify a duration is to indicate its numeric value after a slash.
    # For example, a C note with half duration can be expressed as +C/0.5+
    # This notation does not accept dots or tuplets.
    #
    # The duration of a note can be tied, so its {#tied_duration tied duration} will be
    # added to the next {#tied_elements tied elements}. To indicate the start or end of a tie,
    # add a dash after or before the duration (For example, +Cw- C-w- C-h will tie two
    # whole notes and a half note together). When added to a pattern, one can get the
    # total duration of a note by calling {tied_duration}. All elements other than notes, chords
    # or rests are ignored within tied notes (most notably {Measure measures})
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

      # @param [Tokens::DurationToken, nil] duration_token
      # @param [Rational, Number] default_duration The default duration if there's no token
      def build_duration_from_token(duration_token, default_duration = DEFAULT_DURATION)
        @original_duration_token = duration_token
        @original_duration       = duration_token ? duration_token.text_value : ''
        @processed_value         = Duration.parse_duration(@original_duration_token, default_duration)
        if @original_duration_token
          @start_of_tie          = @original_duration_token.start_of_tie?
          @end_of_tie            = @original_duration_token.end_of_tie?
        end
      end

      # Duration value is proportional to a whole note (one whole note = 1.0 duration).
      #
      # This method will coerce the duration to a float, but internally the elements can
      # handle it as a rational number, to perform calculations more accurately.
      #
      # @return [Number] The value of the duration
      def duration
        case @processed_value
          when Stretto::Value then @processed_value.to_f(@pattern)
          else @processed_value
        end
      end

      # @return [Boolean] If the note starts a tie, indicating the duration should continue
      #   onto the next element
      def start_of_tie?
        @start_of_tie.present?
      end

      # @return [Boolean] If the note ends a tie, indicating the duration should extend
      #   the duration of the previous element
      def end_of_tie?
        @end_of_tie.present?
      end

      # Returns an array containing all the elements that are tied to the right
      #
      # It can return an array consisiting on just the current element, if it is not tied
      # or simply it doesn't belong to a pattern
      #
      # @return [Array(MusicElements::MusicElement)] Array of tied elements
      def tied_elements
        current = self
        elements = [current]
        while next_is_tied?(current)
          current = current.next
          elements << current unless current.kind_of?(Measure)
        end
        elements
      end

      # Returns the total duration of the tied elements
      #
      # @return [Number]
      # @see #tied_elements
      def tied_duration
        tied_elements.inject(0){|sum, element| sum + element.duration}
      end

      # Parses duration from a token, or returning the default duration
      #
      # @return [Rational, Number]
      def self.parse_duration(duration_token, default_duration = DEFAULT_DURATION)
        if !duration_token
          default_duration
        elsif duration_token.value
          duration_token.value
        else
          parse_duration_token(duration_token)
        end
      end

      private

        # Returns whether this note is start of tie, and the next one has end of tie.
        # Ignores Measures, so it will return true even when there's one in between
        #
        # @return [Boolean]
        def next_is_tied?(note)
          note.start_of_tie?      &&
            note.next             &&
            note.next.end_of_tie? &&
            (note.class == note.next.class || note.next.kind_of?(Measure) || note.kind_of?(Measure))
        end

        class << self

          private

            # Parses the duration when it comes as characters + modifiers
            # (e.g. "wh.", "q*3:5")
            #
            # @return [Rational, Number]
            def parse_duration_token(duration_token)
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

    end

  end
end