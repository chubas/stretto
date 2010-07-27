require File.join(File.dirname(__FILE__), 'layer')

module Stretto

  # Represent a _channel_ or _track_, according to the MIDI
  # specification. Each voice has an individual key signature,
  # instrument, and for some values, different controller variables
  #
  # The MIDI specification allows a pattern to have up to 16
  # channels, being the channel 9 the percussion 1.
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
    # @return [Array(MusicElement)] Its elements as an array
    def elements
      to_a
    end

    # Appends an element to the voice, creating an additional layer
    # if necessary.
    def <<(element)
      if element.kind_of?(Stretto::MusicElements::LayerChange)
        @current_layer = (@layers[element.index] ||= Layer.new)
      else
        @layers[DEFAULT_LAYER_INDEX] = @current_layer = Layer.new unless @current_layer
        @current_layer << element
      end
      super(element)
    end

    # Accesor for the {Layer layer} in the specified +index+
    def layer(index)
      @layers[index]
    end

  end

end