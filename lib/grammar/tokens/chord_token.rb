require File.join(File.dirname(__FILE__), '../music_elements/chord')

module Stretto
  module Tokens
    class ChordToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::Chord.new(text_value,
          :base_note => {
            :original_string      => note_string.text_value,
            :original_octave      => octave,
            :original_accidental  => accidental,
            :original_key         => key
          },
          :named_chord            => named_chord.text_value,
          :original_inversions    => inversions
        )
      end

      def inversions
        if chord_inversions and chord_inversions.text_value.present?
          { :inversions => chord_inversions.inversions,
            :pivot_note => chord_inversions.pivot_note && Stretto::MusicElements::Note.new(
                chord_inversions.pivot_note.text_value,
                :original_key         => (chord_inversions.pivot_note.key.text_value        if chord_inversions.pivot_note.key),
                :original_value       => (chord_inversions.pivot_note.value.text_value      if chord_inversions.pivot_note.value),
                :original_accidental  => (chord_inversions.pivot_note.accidental.text_value if chord_inversions.pivot_note.accidental) 
            )
          }
        end
      end

      # TODO: This is shared with note. Extract note_string
      def octave
        note_string.octave.text_value if note_string.octave
      end

      def accidental
        note_string.accidental.text_value if note_string.accidental
      end

      def key
        note_string.key.text_value if note_string.key
      end

      def value
        note_string.value.text_value if note_string.value
      end

    end
  end
end