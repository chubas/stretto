require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), 'note_string_token')
require File.join(File.dirname(__FILE__), 'attack_decay_token')
require File.join(File.dirname(__FILE__), '../../music_elements/chord')

module Stretto
  module Tokens
    class ChordToken < Treetop::Runtime::SyntaxNode

      include WithDurationToken
      include WithNoteStringToken
      include WithAttackDecayToken

      def to_stretto(pattern = nil)
        Stretto::MusicElements::Chord.new(
            text_value,
            :base_note => {
                :original_string        => note_string.text_value,
                :original_octave        => octave,
                :original_accidental    => accidental,
                :original_key           => key,
                :original_value         => value,
                :original_attack        => attack,
                :original_decay         => decay
            },
            :original_duration_token  => duration,
            :named_chord              => named_chord.text_value,
            :original_inversions      => inversions,
            :pattern                  => pattern
        )
      end

      def inversions
        if chord_inversions and chord_inversions.text_value.present?
          { :inversions => chord_inversions.inversions,
            :pivot_note => chord_inversions.pivot_note }
        end
      end

    end
  end
end