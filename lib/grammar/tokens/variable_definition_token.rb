require File.join(File.dirname(__FILE__), '../../music_elements/variable_definition')

module Stretto
  module Tokens

    class VariableDefinitionToken < Treetop::Runtime::SyntaxNode

      def to_stretto(pattern = nil)
        Stretto::MusicElements::VariableDefinition.new(
            text_value,
            :original_name  => name.text_value,
            :name           => name.text_value,
            :original_value => value.text_value,
            :value          => Stretto::Value.new(value.wrap),
            :pattern        => pattern
        )
      end

    end

  end
end