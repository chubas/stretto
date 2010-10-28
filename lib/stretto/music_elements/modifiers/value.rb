require File.dirname(__FILE__) + '/variables'

module Stretto

  # This class acts as a placeholder for values contained by musical elements.
  #
  # It is needed in order to retrieve values held by a variable until evaluation,
  # looking for them in the pattern the element belongs, or one of the predefined
  # variables.
  class Value

    # Wraps a numeric value
    # @see Value
    class NumericValue
      
      attr_reader :numeric

      # @param [Number] The numeric value held
      def initialize(numeric)
        @numeric = numeric
      end

      # @return [Integer] The numeric value coerced to an integer
      def to_i(pattern)
        @numeric.to_i
      end

      # @return [Float] The numeric value coerced to a float
      def to_f(pattern)
        @numeric.to_f
      end

      # @return [Boolean] True if the value it is holding is equal to other's value
      def ==(other)
        other.kind_of?(NumericValue) && other.numeric == @numeric
      end

      # @return [String] The string representation of the numeric value
      def to_s
        @numeric.to_s
      end
    end

    #--------------------------------------------------------------

    # Wraps a variable value, that is, holds a reference to a value that is going
    # to be evaluated until requested.
    #
    # @see Value
    class VariableValue

      include Variables

      attr_reader :name

      # @param [String] The name that references the variable
      def initialize(name)
        @name = name
      end

      # Returns the value of the variable as an integer
      #
      # @return [Integer]
      # @raise (see #get_numeric_value)
      def to_i(pattern)
        get_numeric_value(pattern){ |value| value.to_i(pattern) }
      end

      # Returns the value of the variable as a float
      #
      # @return [Float]
      # @raise (see #get_numeric_value)
      def to_f(pattern)
        get_numeric_value(pattern){ |value| value.to_f(pattern) }
      end

      # Returns either the variable value if attached to a pattern, or raises an exception
      # if there is no pattern attached and the variable is not one of the predefined ones.
      def value(pattern)
        if pattern
          pattern.variable(@name)
        else
          predefined = PREDEFINED_VARIABLES[name.upcase]
          unless predefined
            raise Stretto::Exceptions::VariableContextException.new(
                "A pattern is needed to access variable #{@name}")
          end
          Value.new(Value::NumericValue.new(predefined))
        end
      end

      # Returns whether the other object is the same class and holds the same variable name
      def ==(other)
        other.kind_of?(VariableValue) && other.name == @name
      end

      # Name of the variable, enclosed in brackets
      #
      # @return [String]
      def to_s
        "[#{@name}]"
      end

      private

        # Gets the numeric value of the variable.
        #
        # It does indirection, that is, if the value holding is a variable itself,
        # looks up recursively.
        #
        # @raise [VariableContextException] if the variable is not one of the predefined values
        #   and there is no pattern attached
        # @raise [VariableNotDefinedException] if the variable is not defined in the pattern
        def get_numeric_value(pattern)
          variable = self
          variable = yield variable.value(pattern) until variable.kind_of?(Numeric)
          variable
        end
    end

    #--------------------------------------------------------------

    # Initializes with the value passed in, and an optional variation.
    #
    # @param value [NumericValue, VariableValue]
    # @param variation [Number] Works as a delayed addition, so you can do things like
    #      `Value.new(VariableValue.new("SOME_VAR")) + 1`
    #   and have it evaluated until requested 
    def initialize(value, variation = nil)
      @value = value
      @variation = variation
    end

    # Converts the value to integer
    #
    # @return [Integer, nil]
    def to_i(pattern)
      if @value
        result = @value.to_i(pattern)
        result += @variation if @variation
        result
      end
    end

    # Converts the value to float
    #
    # @return [Float, nil]
    def to_f(pattern)
      if @value
        result = @value.to_f(pattern)
        result += @variation if @variation
        result
      end
    end

    # Adds a variation to the Value, returning a new one with the sum of variations
    #
    # @return [Value]
    def +(variation)
      new_variation = [@variation, variation].compact.sum
      self.class.new(@value, new_variation)
    end

    # String representation for this value, either a number or the name of the variable.
    def to_s
      output = @value.to_s
      output += "+#{@variation}" if @variation
      output
    end

  end
end