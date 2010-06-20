require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), '../../music_elements/rest')

module Stretto
  module Tokens
    class RestToken < Treetop::Runtime::SyntaxNode

      include WithDurationToken

      def to_stretto
        Stretto::MusicElements::Rest.new(
            text_value, 
            :original_duration_token => duration
        )
      end

    end
  end
end