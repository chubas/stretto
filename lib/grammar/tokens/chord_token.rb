require File.join(File.dirname(__FILE__), '../music_elements/chord')

module Stretto
  module Tokens
    class ChordToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::Chord.new(text_value,
          :base_note => {
            :original_string        => note_string.text_value,
            :original_octave        => octave,
            :original_accidental    => accidental,
            :original_key           => key,
            :original_value         => value
          },
          :original_duration_token  => duration,
          :named_chord              => named_chord.text_value,
          :original_inversions      => inversions
        )
      end

      def inversions
        if chord_inversions and chord_inversions.text_value.present?
          { :inversions => chord_inversions.inversions,
            :pivot_note => chord_inversions.pivot_note }
        end
      end

      # TODO: This is shared with note. Extract note_string
      def octave
        note_string.octave
      end

      def accidental
        note_string.accidental
      end

      def key
        note_string.key
      end

      def value
        note_string.value
      end

      def duration
        _duration if _duration and _duration.text_value.present?
      end

    end
  end
end