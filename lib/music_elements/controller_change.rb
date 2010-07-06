require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class ControllerChange < MusicElement

      attr_reader :controller, :value

      def initialize(original_string, options = {})
        @original_string = original_string
        @controller = options[:original_controller].to_i
        @value      = options[:original_value].to_i
      end

    end

  end
end