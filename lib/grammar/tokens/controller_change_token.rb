require File.join(File.dirname(__FILE__), '../../music_elements/controller_change')

module Stretto
  module Tokens
    class ControllerChangeToken < Treetop::Runtime::SyntaxNode

      def to_stretto(pattern)
        Stretto::MusicElements::ControllerChange.new(
            text_value,
            :original_controller  => controller.text_value,
            :original_value       => value.text_value,
            :pattern              => pattern
        )
      end

    end
  end
end