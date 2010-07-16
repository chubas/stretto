require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), '../../music_elements/rest')

module Stretto
  module Tokens
    class RestToken < HashToken

      include WithDurationToken

      # OPTIMIZE: Validates that duration is always a duration token, wrapping a nil value if needed
      def to_stretto(pattern = nil)
        Stretto::MusicElements::Rest.new(self, pattern)
      end

    end
  end
end