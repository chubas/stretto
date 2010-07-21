require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), 'note_string_token')
require File.join(File.dirname(__FILE__), 'attack_decay_token')
require File.join(File.dirname(__FILE__), '../../music_elements/chord')

module Stretto
  module Tokens
    class ChordToken < HashToken

      include WithDurationToken
      include WithNoteStringToken
      include WithAttackDecayToken

      def to_stretto(pattern = nil)
        Stretto::MusicElements::Chord.new(self, pattern)
      end

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

      def note_string
        __note_string
      end

      def named_chord
        __named_chord.text_value
      end

      def inversions
        if __chord_inversions and __chord_inversions.text_value.present?
          { :inversions => __chord_inversions.inversions,
            :pivot_note => __chord_inversions.pivot_note }
        end
      end

      def notes
        nil
      end

    end
  end
end