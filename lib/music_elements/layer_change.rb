require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class LayerChange < MusicElement

      MAX_LAYERS = 15

      attr_reader :index

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_value = options[:value]

        # TODO: As layer is inherent to a pattern, raise an error if @pattern is nil
        self.index = @original_value.to_i(@pattern)
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