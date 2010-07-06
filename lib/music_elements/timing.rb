require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Timing < MusicElement

      attr_reader :value

      def initialize(original_string, options = {})
        super(original_string, options)
        @value = options[:original_value].to_i
      end

    end

  end
end