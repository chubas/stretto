require File.join(File.dirname(__FILE__), '../../music_elements/harmony')
require File.join(File.dirname(__FILE__), '../../music_elements/melody')

module Stretto
  module Tokens
    class HarmonyWithMelodyToken < Treetop::Runtime::SyntaxNode

      def to_stretto(pattern = nil)
        elements = harmony_elements(pattern)
        if elements.size == 1 and elements.first.kind_of?(Stretto::MusicElements::Melody)
          elements.first
        else
          Stretto::MusicElements::Harmony.new(
              text_value,
              :original_elements => elements,
              :pattern           => pattern
          )
        end
      end

      # TODO: This can be refactored, even return the melodies directly from the token
      def harmony_elements(pattern)
        elements = [_first_element.to_stretto]
        original_strings = [_first_element.text_value]
        _other_elements.elements.each do |e|
          element = e._element.to_stretto
          case e._sep.text_value
            when '_'
              elements << [elements.pop] unless elements.last.kind_of?(Array)
              elements.last << element
              original_strings[-1] += element.original_string
            when '+'
              elements << element
              original_strings << element.original_string
          end
        end
        elements.zip(original_strings).map do |element, string|
          if element.kind_of?(Array)
            Stretto::MusicElements::Melody.new(
                string,
                :original_elements  => element,
                :pattern            => pattern
            )
          else
            element
          end
        end
      end

    end
  end
end