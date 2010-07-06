require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class LayerChange < MusicElement

      attr_reader :index

      def initialize(original_string, options = {})
        super(original_string, options)
        self.index = options[:original_value].to_i
      end

      def index=(index)
        if index < 0 or index > 15
          raise Exceptions::ValueOutOfBoundsException.new("Layer value should be in range 0..15")
        end
        @index = index
      end

    end

  end
end