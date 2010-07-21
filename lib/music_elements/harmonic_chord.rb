require File.join(File.dirname(__FILE__), 'music_element')
require File.join(File.dirname(__FILE__), 'chord')

module Stretto
  module MusicElements
    class HarmonicChord < Chord

      def initialize(string_hash_or_token, pattern = nil)
        token = case string_hash_or_token
          when String then Stretto::Parser.parse_harmonic_chord!(string_hash_or_token)
          else string_hash_or_token
        end
        super(token, :pattern => pattern)
        @notes = normalize_notes(@notes)
      end

      def elements
        notes
      end

      def duration
        @notes.map(&:duration).max
      end

      def substitute_variables!
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
        end.uniq
      end

    end
  end
end