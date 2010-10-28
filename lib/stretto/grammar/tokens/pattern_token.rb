module Stretto
  module Tokens

    # This is the token that parses a pattern, that is, a collection of music elements
    #
    # @example "T[ALLEGRO] I[PIANO] | C C D E | Rw. | Dmin"
    module PatternToken

      # @return [Array(MusicElements::MusicElement)] An array containing all the elements of
      #   the pattern
      #-
      # TODO: This should return a Pattern object directly
      def to_stretto(pattern = nil)
        unless head.text_value.empty?
          [head.to_stretto(pattern)] + more_elements.elements.map do |element|
            element.music_element.to_stretto(pattern)
          end
        else
          []
        end
      end

    end

  end
end