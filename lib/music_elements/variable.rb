require File.join(File.dirname(__FILE__), 'music_element')


module Stretto
  module MusicElements

    # Holds a value, identified by a name, that can be used in some elements in the pattern.
    #
    # The syntax for setting a value is $_name_=_vaue_
    #
    # For example, in a pattern
    #
    #     $SOME_VARIABLE=80 [SOME_VARIABLE]
    #
    # the note will have a picth of 80, as defined by the variable _SOME_VARIABLE_
    #
    # Value can be either a numeric value or another variable. Note that predefined variables are
    # not constants; they can be overriden at any time, and the elements after the new definition
    # will take its most recent value.
    #
    # @see Value
    class Variable < MusicElement

      attr_reader :name, :value

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_variable!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @value = token[:value]
        @name  = token[:name]
      end

      # @return (see Value#to_i)
      def to_i
        @value.to_i(@pattern)
      end

      # @return (see Value#to_f)
      def to_f
        @value.to_f(@pattern)
      end

    end

  end
end