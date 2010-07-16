require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class LayerChange < MusicElement

      MAX_LAYERS = 15

      attr_reader :index

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_layer_change!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern)
        @original_value = token[:value]
      end

      def index
        @index || @original_value.to_i(@pattern)
      end

      def index=(index)
        if index < 0 or index > MAX_LAYERS
          raise Exceptions::ValueOutOfBoundsException.new("Layer value should be in range 0..#{MAX_LAYERS}")
        end
        @index = index
      end

      def substitute_variables!
        self.index = index
      end

    end

  end
end