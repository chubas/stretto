require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class ControllerChange < MusicElement

      attr_reader :controller, :value

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_controller_change!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @original_controller = token[:controller]
        @original_value      = token[:value]
      end

      def substitute_variables!
        @controller = @original_controller.to_i(@pattern)
        @value      = @original_value.to_i(@pattern)
      end

      def controller
        @controller || @original_controller.to_i(@pattern)
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

    end

  end
end