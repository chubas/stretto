require File.join(File.dirname(__FILE__), '../../music_elements/instrument')
require File.join(File.dirname(__FILE__), '../../music_elements/voice_change')
require File.join(File.dirname(__FILE__), '../../music_elements/layer_change')
require File.join(File.dirname(__FILE__), '../../music_elements/tempo')
require File.join(File.dirname(__FILE__), '../../music_elements/pitch_wheel')
require File.join(File.dirname(__FILE__), '../../music_elements/channel_pressure')
require File.join(File.dirname(__FILE__), '../../music_elements/timing')

module Stretto
  module Tokens
    class ModifierToken < Treetop::Runtime::SyntaxNode

      def to_stretto
        klass = case kind.text_value
          when 'I'
            Stretto::MusicElements::Instrument
          when 'V'
            Stretto::MusicElements::VoiceChange
          when 'L'
            Stretto::MusicElements::LayerChange
          when 'T'
            Stretto::MusicElements::Tempo
          when '&'
            Stretto::MusicElements::PitchWheel
          when '+'
            Stretto::MusicElements::ChannelPressure
          when '@'
            Stretto::MusicElements::Timing
        end
        klass.new(text_value, :original_value => value.text_value)
      end

    end
  end
end