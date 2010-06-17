require File.join(File.dirname(__FILE__), '../music_elements/note')

module Stretto
  module Tokens
    class NoteToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        Stretto::MusicElements::Note.new(
            text_value,
            :original_duration_token  => duration,
            :original_key             => key,
            :original_accidental      => accidental,
            :original_octave          => octave,
            :original_value           => value
          )
      end

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