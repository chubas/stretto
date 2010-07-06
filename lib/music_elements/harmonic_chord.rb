require File.join(File.dirname(__FILE__), 'music_element')
require File.join(File.dirname(__FILE__), 'chord')

module Stretto
  module MusicElements
    class HarmonicChord < Chord

      include Duration

      #-
      # TODO: This should be able to call super()
      def initialize(original_string, options = {})
        @original_string = original_string
        @base_notes      = options[:original_base_notes]
        @notes           = normalize_notes(@base_notes)
        @duration        = @notes.map(&:duration).max
      end

      def elements
        notes
      end

      def normalize_notes(base_notes)
        base_notes.inject([]) do |notes, element|
          case element
            when Note   then notes << element
            when Chord  then notes += element.notes
          end
          notes
        end.uniq
      end

    end
  end
end