require File.join(File.dirname(__FILE__), '../../music_elements/controller_change')

module Stretto
  module Tokens
    
    # Token result from parsing a controller change
    class ControllerChangeToken < HashToken

      # @return [MusicElements::ControllerChange]
      def to_stretto(pattern)
        Stretto::MusicElements::ControllerChange.new(self, pattern)
      end

      # @return [Value]
      def controller
        Value.new(__controller.wrap)
      end

      # @return [Value]
      def value
        Value.new(__value.wrap)
      end

    end
  end
end