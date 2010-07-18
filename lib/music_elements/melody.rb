require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    class Melody < MusicElement

      attr_reader :elements

      def initialize(array_or_hash, pattern = nil)
        options = _handle_initial_argument(array_or_hash)
        _verify_is_pattern(pattern)
        @elements = options[:elements]
        super(options[:original_string], :pattern => pattern)
      end

      def duration
        @elements.map(&:duration).sum
      end

      def <<(element)
        @elements << element
        element.pattern = @pattern if @pattern
      end

      private

        def _handle_initial_argument(array_hash_or_music_element)
          arg = array_hash_or_music_element
          case arg
            when Array
              unless arg.present? and arg.all? { |element| element.kind_of?(MusicElement) }
                raise ArgumentError.new("First argument should be either a MusicElement or an array of at least one MusicElement")
              end
              { :elements   => arg,
                :text_value => arg.map(&:original_string).join('_')
              }
            when Hash
              arg
            when MusicElement
              { :elements   => [arg],
                :text_value => arg.original_string
              }
            else raise ArgumentError.new("First argument should be either a MusicElement or an array of MusicElements")
          end
        end

        def _verify_is_pattern(pattern)
          if pattern and !pattern.kind_of?(Pattern)
            raise ArgumentError.new("Second argument should be a Pattern object or nil")
          end
        end

    end
  end
end