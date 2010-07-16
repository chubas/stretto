require File.join(File.dirname(__FILE__), '../../music_elements/variable')

module Stretto
  module Tokens

    class VariableDefinitionToken < HashToken

      def to_stretto(pattern = nil)
        Stretto::MusicElements::Variable.new(self, pattern)
      end

      def name
        __name.text_value
      end

      def value
        Stretto::Value.new(__value.wrap)
      end

    end

  end
end