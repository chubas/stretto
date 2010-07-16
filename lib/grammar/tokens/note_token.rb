require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), 'note_string_token')
require File.join(File.dirname(__FILE__), 'attack_decay_token')
require File.join(File.dirname(__FILE__), '../../music_elements/note')

module Stretto
  module Tokens
    class NoteToken < HashToken

      include WithDurationToken
      include WithNoteStringToken
      include WithAttackDecayToken

      def to_stretto(pattern = nil)
        Stretto::MusicElements::Note.new(self, pattern)
      end

    end
  end
end