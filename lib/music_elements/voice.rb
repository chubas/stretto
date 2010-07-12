require File.join(File.dirname(__FILE__), 'layer')

module Stretto

  class Voice < Array

    DEFAULT_LAYER_INDEX = 0

    attr_reader :layers
    attr_reader :index

    def initialize(index, *args)
      @layers = {}
      @index = index
      super(*args)
    end

    # Method intended to keep consistency between array-like structures
    def elements
      to_a
    end

    def <<(element)
      if element.kind_of?(Stretto::MusicElements::LayerChange)
        @current_layer = (@layers[element.index] ||= Layer.new)
      else
        @layers[DEFAULT_LAYER_INDEX] = @current_layer = Layer.new unless @current_layer
        @current_layer << element
      end
      super(element)
    end

    def layer(index)
      @layers[index]
    end

  end

end