require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), 'note_string_token')
require File.join(File.dirname(__FILE__), '../../music_elements/note')

module Stretto
  module Tokens
    class NoteToken < Treetop::Runtime::SyntaxNode

      include WithDurationToken
      include WithNoteStringToken

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

    end
  end
end