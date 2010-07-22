require File.join(File.dirname(__FILE__), '../../music_elements/variable')

module Stretto
  module Tokens

    # Token from parsing a variable definition
    #
    # @example "$MY_VAR=80", "$OTHER_VAR=[SOME_NOTE_VAR]"
    class VariableDefinitionToken < HashToken

      # @return [MusicElements::Variable] The constructed Variable element
      def to_stretto(pattern = nil)
        Stretto::MusicElements::Variable.new(self, pattern)
      end

      # @return [String] The name of the variable
      def name
        __name.text_value
      end

      # @return [Value] The value of the variable, a Value object
      #   wrapping either a numeric or another variable value
      def value
        Stretto::Value.new(__value.wrap)
      end

    end

  end
end