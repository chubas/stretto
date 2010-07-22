require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), '../../music_elements/rest')

module Stretto
  module Tokens

    # Token from parsing a rest element
    #
    # @example "R", "Rq"
    class RestToken < HashToken

      include WithDurationToken

      # @return [MusicElement::Rest] The Rest element constructed
      def to_stretto(pattern = nil)
        Stretto::MusicElements::Rest.new(self, pattern)
      end

    end
  end
end