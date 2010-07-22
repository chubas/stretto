require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), 'note_string_token')
require File.join(File.dirname(__FILE__), 'attack_decay_token')
require File.join(File.dirname(__FILE__), '../../music_elements/chord')

module Stretto
  module Tokens

    # Parses a named chord
    #
    # @example: "C5#maj"
    class ChordToken < HashToken

      include WithDurationToken
      include WithNoteStringToken
      include WithAttackDecayToken

      # @return [MusicElements::Chord] The constructed Chord element
      def to_stretto(pattern = nil)
        Stretto::MusicElements::Chord.new(self, pattern)
      end

      # Returns a base note hash, which can be seen as a token returned by the
      # parsed note
      def base_note
        {
            :text_value => note_string.text_value,
            :key        => key,
            :pitch      => pitch,
            :accidental => accidental,
            :octave     => octave,
            :attack     => attack,
            :decay      => decay,
            :duration   => duration
        }
      end

      # @return [NoteStringToken]
      def note_string
        __note_string
      end

      # @return A string containing the named chord
      # @example "sus4"
      def named_chord
        __named_chord.text_value
      end

      # If inversions are present, return a hash containing the pivot note
      #   (e.g. "^C") or the number of inversions (e.g. 5)
      def inversions
        if __chord_inversions and __chord_inversions.text_value.present?
          { :inversions => __chord_inversions.inversions,
            :pivot_note => __chord_inversions.pivot_note }
        end
      end

      # Don't precalculate values. Added for harmonic chords to be able to be
      # constructed from a chord token.
      # @private
      def notes
        nil
      end

    end
  end
end