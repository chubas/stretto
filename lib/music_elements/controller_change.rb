require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class ControllerChange < MusicElement

      attr_reader :controller, :value

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_controller = options[:original_controller]
        @original_value      = options[:original_value]
      end

      def substitute_variables!
        @controller = @original_controller.to_i(@pattern)
        @value      = @original_value.to_i(@pattern)
      end

    end

  end
end