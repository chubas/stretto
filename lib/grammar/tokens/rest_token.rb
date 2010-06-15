require File.join(File.dirname(__FILE__), '../music_elements/rest')

module Stretto
  module Tokens
    class RestToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::Rest.new(:original_duration => duration.text_value)
      end

    end
  end
end