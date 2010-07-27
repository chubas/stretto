require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # A set of elements that should play sequentially. The elements are separated
    # by underscores, for example <tt>C_D_E</tt>
    #
    # A melody alone would be the equivalent to play the elements of it separately,
    # but it is useful to indicate explicitely a melody when used in harmonies
    # (see {Harmony}). For example, a harmony (C_D+E_Fmaj) will play at the same time
    # +C+ + +E+ for one quarter of a whole note, then +D+ and +Fmaj+ will play together. 
    class Melody < MusicElement

      attr_reader :elements

      def initialize(array_or_hash, pattern = nil)
        options = _handle_initial_argument(array_or_hash)
        _verify_is_pattern(pattern)
        @elements = options[:elements]
        super(options[:original_string], pattern)
      end

      # Returns the sum of the duration of its elements
      def duration
        @elements.map(&:duration).sum
      end

      # Adds an element to the melody, additionally setting its pattern
      # (see {MusicElement::pattern=)
      def <<(element)
        @elements << element
        element.pattern = @pattern if @pattern
      end

      private

        # @private
        # Builds the set of elements based on what the constructor is (a token,
        # an array of elements or a single MusicElement (in which case, a melody
        # with just one element is created.)
        def _handle_initial_argument(array_hash_or_music_element)
          arg = array_hash_or_music_element
          case arg
            when Array
              unless arg.present? and arg.all? { |element| element.kind_of?(MusicElement) }
                raise ArgumentError.new("First argument should be either a MusicElement or an array of at least one MusicElement")
              end
              { :elements   => arg,
                :original_string => arg.map(&:original_string).join('_')
              }
            when Hash
              arg
            when MusicElement
              { :elements   => [arg],
                :original_string => arg.original_string
              }
            else raise ArgumentError.new("First argument should be either a MusicElement or an array of MusicElements")
          end
        end

        # @private
        # Verifies that the second parameter in initializer is a {Pattern}
        def _verify_is_pattern(pattern)
          if pattern and !pattern.kind_of?(Pattern)
            raise ArgumentError.new("Second argument should be a Pattern object or nil")
          end
        end

    end
  end
end