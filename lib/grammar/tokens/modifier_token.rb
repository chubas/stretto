require File.join(File.dirname(__FILE__), '../../music_elements/instrument')
require File.join(File.dirname(__FILE__), '../../music_elements/voice_change')

module Stretto
  module Tokens
    class ModifierToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        case kind.text_value
          when 'I'
            Stretto::MusicElements::Instrument.new(
                text_value,
                :original_value => value.text_value
            )
          when 'V'
            Stretto::MusicElements::VoiceChange.new(
                text_value,
                :original_value => value.text_value
            )
        end
      end

    end
  end
end