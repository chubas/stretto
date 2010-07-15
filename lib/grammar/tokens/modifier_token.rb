require File.join(File.dirname(__FILE__), '../../music_elements/modifiers/value')
require File.join(File.dirname(__FILE__), '../../music_elements/instrument')
require File.join(File.dirname(__FILE__), '../../music_elements/voice_change')
require File.join(File.dirname(__FILE__), '../../music_elements/layer_change')
require File.join(File.dirname(__FILE__), '../../music_elements/tempo')
require File.join(File.dirname(__FILE__), '../../music_elements/pitch_wheel')
require File.join(File.dirname(__FILE__), '../../music_elements/channel_pressure')
require File.join(File.dirname(__FILE__), '../../music_elements/timing')

module Stretto
  module Tokens

    class ModifierToken < HashToken

      def to_stretto(pattern = nil)
        self.class::KLASS.new(self, pattern)
      end

      def value
        Value.new(__value.wrap)
      end
      
    end

    class InstrumentToken < ModifierToken
      KLASS = Stretto::MusicElements::Instrument
    end

    class VoiceChangeToken < ModifierToken
      KLASS = Stretto::MusicElements::VoiceChange
    end

    class LayerChangeToken < ModifierToken
      KLASS = Stretto::MusicElements::LayerChange
    end

    class TempoToken < ModifierToken
      KLASS = Stretto::MusicElements::Tempo
    end

    class PitchWheelToken < ModifierToken
      KLASS = Stretto::MusicElements::PitchWheel
    end

    class ChannelPressureToken < ModifierToken
      KLASS = Stretto::MusicElements::ChannelPressure
    end

    class TimingToken < ModifierToken
      KLASS = Stretto::MusicElements::Timing
    end

  end
end