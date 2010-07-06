require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class LayerChange < MusicElement

      MAX_LAYERS = 15

      attr_reader :index

      def initialize(original_string, options = {})
        super(original_string, options)
        self.index = options[:original_value].to_i
      end

      def index=(index)
        if index < 0 or index > MAX_LAYERS
          raise Exceptions::ValueOutOfBoundsException.new("Layer value should be in range 0..#{MAX_LAYERS}")
        end
        @index = index
      end

    end

  end
end