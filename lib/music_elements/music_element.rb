require File.join(File.dirname(__FILE__), '../util/node')
require File.join(File.dirname(__FILE__), 'modifiers/duration')

module Stretto
  module MusicElements

    # Superclass of all music elements in Stretto.
    #
    # These are all the elements than can be added to a pattern, most of them represent some
    # data to be sent to a MIDI channel, or are some notation element to aid in the composition.
    class MusicElement

      include Stretto::Node

      # In the case of parsed element, this is the originating string.
      # In the case of calculated elements, this should be an empty string, and its string
      # representation must be provided by the element
      #
      # @return [String, nil]
      attr_reader   :original_string

      # The pattern to where this element belongs. Used to make calculations about key signatures,
      # ties, instruments, voices, etc. that may modify the element itself.
      #
      # @return [Pattern, nil]
      attr_reader   :pattern

      # Stores the original string and an optional pattern
      def initialize(original_string, pattern = nil)
        @original_string = original_string # TODO: Validates always an original string?
        @pattern         = pattern
      end

      # @return The string representation of the element
      # @todo No specs for this. Ideally, its string representation should be one that can be
      #   parsed again to retrieve the same element
      def to_s
        original_string || build_music_string
      end

      # @abstract
      # @todo Not yet implemented
      def build_music_string
        raise "build_music_string not implemented in #{self.class}"
      end

      alias inspect to_s

      # By default, it is true, so we can tie notes with elements in between
      def start_of_tie?
        true
      end

      # By default, it is true, so we can tie notes with elements in between
      def end_of_tie?
        true
      end

      # By default, duration is 0
      #
      # The correct duration should be overriden by subclasses
      def duration
        0
      end

      # @private
      #
      # Called whenever an element is attached to a pattern, and its attributes need to be
      # recalculated / validated (because of variables, key signatures, ties, etc.)
      #
      # Each element class must override this class to provide the callback when the element
      # is added to a pattern.
      def substitute_variables!
        # TODO: Big TODO - Change this method's name for a callback.
      end

      # Assigns the pattern to the element, and runs any associated callback
      #
      # @see #substitute_variables!
      def pattern=(pattern)
        @pattern = pattern
        substitute_variables! # TODO: Remove this call
      end

    end

  end
end