require File.join(File.dirname(__FILE__), 'chord')
require File.join(File.dirname(__FILE__), 'modifiers/duration')

module Stretto
  module MusicElements
    class HarmonicChord < Chord

      include Duration

      def initialize(text_value, options = {})
        @original_string = text_value
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