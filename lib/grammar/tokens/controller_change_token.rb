require File.join(File.dirname(__FILE__), '../../music_elements/controller_change')

module Stretto
  module Tokens
    class ControllerChangeToken < HashToken

      def to_stretto(pattern)
        Stretto::MusicElements::ControllerChange.new(self, pattern)
      end

      def controller
        Value.new(__controller.wrap)
      end

      def value
        Value.new(__value.wrap)
      end

    end
  end
end