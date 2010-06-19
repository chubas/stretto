require File.join(File.dirname(__FILE__), 'modifiers/duration')

module Stretto
  module MusicElements
    class Rest

      include Duration

      attr_reader :original_duration, :duration

      def initialize(options = {})
        @original_duration_token = options[:original_duration_token]
        @original_duration       = @original_duration_token.text_value if @original_duration_token
        @duration                = parse_duration(@original_duration_token)
      end

    end
  end
end