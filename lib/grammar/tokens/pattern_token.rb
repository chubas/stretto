module Stretto
  module Tokens

    module PatternToken

      def to_stretto
        unless head.text_value.empty?
          [head.to_stretto] + more_elements.elements.map{|element| element.music_element.to_stretto }
        else
          []
        end
      end

    end

  end
end