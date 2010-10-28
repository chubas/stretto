require File.join(File.dirname(__FILE__), 'music_element')
require File.join(File.dirname(__FILE__), 'chord')

module Stretto
  module MusicElements

    # Represents a non-regular chord (see {Chord})
    #
    # A harmonic chord can be specied by joining notes, or even chords, together with
    # the <tt>+</tt> symbol. For example, the chord <tt>C+E+G</tt> is the same as the chord
    # +Cmaj+, and the chord <tt>C+D+E</tt> is an irregular chord (not included in the
    # standard named chords) which will have the notes +C+, +D+ and +E+. Note that as
    # the notes are specified by their note notation, the default octave is 5, instead of
    # 3 as the normal chords.
    class HarmonicChord < Chord

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_harmonic_chord!(string_or_options)
          else string_or_options
        end
        super(token, pattern)
        @notes = normalize_notes(@notes)
      end

      # @return (see Chord#elements)
      def elements
        notes
      end

      # @return (see Chord#elements)
      def duration
        @notes.map(&:duration).max
      end

      # @private
      def substitute_variables!
        @duration        = @notes.map(&:duration).max
        @notes.each{ |note| note.pattern = @pattern }
      end

      # Builds the +@notes+ instance variable, flattening the notes
      # and the notes in a chord into a single array of elements
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