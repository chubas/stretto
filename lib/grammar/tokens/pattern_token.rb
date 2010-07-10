module Stretto
  module Tokens

    module PatternToken

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