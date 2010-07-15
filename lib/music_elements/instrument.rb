require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Instrument < MusicElement

      MAX_INSTRUMENT_VALUE = 127

      def self.default_instrument(pattern = nil)
        params = {
          :text_value => '',
          :value => Value.new(Value::NumericValue.new(0))
        }
        new(params, pattern)
      end

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_instrument!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token[:text_value], :pattern => pattern )
        @original_value = token[:value]
      end

      def value=(value)
        if value < 0 or value > MAX_INSTRUMENT_VALUE
          raise Exceptions::ValueOutOfBoundsException.new("Instrument value should be in range 0..#{MAX_INSTRUMENT_VALUE}")
        end
        @value = value
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      def substitute_variables!
        self.value = value
      end

    end

  end
end