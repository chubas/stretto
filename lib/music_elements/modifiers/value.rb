require File.dirname(__FILE__) + '/variables'

module Stretto
  class Value

    class NumericValue
      
      attr_reader :numeric

      def initialize(numeric)
        @numeric = numeric
      end

      def to_i(pattern)
        @numeric.to_i
      end

      def to_f(pattern)
        @numeric.to_f
      end

      def ==(other)
        other.kind_of?(NumericValue) && other.numeric == @numeric
      end

      def to_s
        @numeric.to_s
      end
    end

    class VariableValue

      include Variables

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def to_i(pattern)
        value(pattern).to_i(pattern)
      end

      def to_f(pattern)
        value(pattern).to_f(pattern)
      end

      def value(pattern)
        if pattern
          pattern.variable(@name)
        else
          predefined = PREDEFINED_VARIABLES[name.upcase]
          unless predefined
            raise Stretto::Exceptions::VariableContextException.new("A pattern is needed to access variable #{@name}")
          end
          Value.new(Value::NumericValue.new(predefined))
        end
      end

      def ==(other)
        other.kind_of?(VariableValue) && other.name == @name
      end

      def to_s
        "[#{@name}]"
      end
    end

    def initialize(value, variation = nil)
      # OPTIMIZE: Valiudate that value is either nil or a Variable or NUmeric value
      @value = value
      @variation = variation
    end

    def to_i(pattern)
      if @value
        result = @value.to_i(pattern)
        result += @variation if @variation
        result
      end
    end

    def to_f(pattern)
      if @value
        result = @value.to_f(pattern)
        result += @variation if @variation
        result
      end
    end

    def +(variation)
      new_variation = [@variation, variation].compact.sum
      self.class.new(@value, new_variation)
    end

    def has_value?
      @value.present?
    end

    def self.nil_value
      new(nil)
    end

    def to_s
      output = @value.to_s
      output += "+#{@variation}" if @variation
      output
    end

  end
end