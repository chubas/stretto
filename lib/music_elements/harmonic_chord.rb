require File.join(File.dirname(__FILE__), 'music_element')
require File.join(File.dirname(__FILE__), 'chord')

module Stretto
  module MusicElements
    class HarmonicChord < Chord

      def duration
        @notes.map(&:duration).max
      end

      #-
      # TODO: This should be able to call super()
      def initialize(original_string, options = {})
        @original_string = original_string
        @base_notes      = options[:original_base_notes]
      end

      def elements
        notes
      end

      def substitute_variables!
        @notes           = normalize_notes(@base_notes).uniq
        @duration        = @notes.map(&:duration).max
        @notes.each{ |note| note.pattern = @pattern }
      end

      def normalize_notes(base_notes)
        base_notes.inject([]) do |notes, element|
          element.pattern = @pattern
          case element
            when Note   then notes << element
            when Chord  then notes + element.notes
          end
        end
      end

    end
  end
end