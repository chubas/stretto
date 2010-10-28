require File.join(File.dirname(__FILE__), 'duration_token')
require File.join(File.dirname(__FILE__), 'note_string_token')
require File.join(File.dirname(__FILE__), 'attack_decay_token')
require File.join(File.dirname(__FILE__), '../../music_elements/note')

module Stretto
  module Tokens

    # Token result from parsing a note element. It includes the note string, attack, decay and duration
    #
    # @example "C", "F#6", "[60]w.", "Gb/3.0a100d100"
    class NoteToken < HashToken

      include WithDurationToken
      include WithNoteStringToken
      include WithAttackDecayToken

      # @return [MusicElements::Note] The constructed Note element
      def to_stretto(pattern = nil)
        Stretto::MusicElements::Note.new(self, pattern)
      end

    end
  end
end