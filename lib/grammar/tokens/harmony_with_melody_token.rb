require File.join(File.dirname(__FILE__), '../../music_elements/harmony')
require File.join(File.dirname(__FILE__), '../../music_elements/melody')

module Stretto
  module Tokens
    class HarmonyWithMelodyToken < HashToken


      def to_stretto(pattern = nil)
        @pattern = pattern
        music_elements = harmony_elements(pattern)
        if music_elements.size == 1 and music_elements.first.kind_of?(Stretto::MusicElements::Melody)
          music_elements.first
        else
          Stretto::MusicElements::Harmony.new(self, pattern)
        end
      end

      def music_elements
        @music_elements ||= harmony_elements(@pattern)
      end

      private

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
                  { :original_string => string,
                    :elements        => element },
                    pattern
              )
            else
              element
            end
          end
        end

    end
  end
end