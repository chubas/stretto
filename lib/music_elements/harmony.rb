require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Represents a group of notes, chords and rests of different lengths
    # that should play together.
    #
    # It is similar to a HarmonicChord (see {HarmonicChord} with the difference
    # that it can also include rests and melodies (see {Melody})
    class Harmony < MusicElement

      attr_accessor :elements

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_harmony!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @elements = token[:music_elements]
      end

      # @return (see HarmonicChord#duration)
      def duration
        @elements.map(&:duration).max
      end

      # @return (see HarmonicChord#pattern=)
      def pattern=(pattern)
        @elements.each { |element| element.pattern = pattern }
      end

    end

  end
end