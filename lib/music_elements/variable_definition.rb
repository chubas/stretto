require File.join(File.dirname(__FILE__), 'music_element')


module Stretto
  module MusicElements

    class Variable < MusicElement

      attr_reader :name, :value

      def initialize(original_string, options = {})
        super(original_string, options)
        @value = options[:value]
        @name  = options[:name]
      end

      def to_i
        @value.to_i(@pattern)
      end

      def to_f
        @value.to_f(@pattern)
      end

    end

  end
end