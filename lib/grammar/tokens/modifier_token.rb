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

    # Token result from parsing a modifier token.
    # This encloses all elements that are constructed by a single character and a value.
    # Refer to individual class to see the MusicElement generated from this token
    #
    # @example "I40". "T[ALLEGRO]", "@2000"
    class ModifierToken < HashToken

      # Returns an element of class KLASS
      # @abstract
      # @return [MusicElements::MusicElement]
      # @see ModifierToken::KLASS
      def to_stretto(pattern = nil)
        self.class::KLASS.new(self, pattern)
      end

      # @return [Value] A Value object wrapping the value of the modifier
      def value
        Value.new(__value.wrap)
      end
      
    end

    # Token result from parsing a duration
    #
    # @example "I[FLUTE]"
    class InstrumentToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::Instrument
    end

    # Token result from parsing a voice
    #
    # @example "V10"
    class VoiceChangeToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::VoiceChange
    end

    # Token result from parsing a layer
    #
    # @example "L5"
    class LayerChangeToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::LayerChange
    end

    # Token result from parsing a tempo
    #
    # @example "T200", "T[ALLEGRO]"
    class TempoToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::Tempo
    end

    # Token result from parsing a pitch wheel
    #
    # @example "wh", "q*3:4", "/2.5"
    class PitchWheelToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::PitchWheel
    end

    # Token result from parsing a channel pressure
    #
    # @example "+80"
    class ChannelPressureToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::ChannelPressure
    end

    # Token result from parsing a timing indication
    #
    # @example "@2000"
    class TimingToken < ModifierToken

      # @private
      KLASS = Stretto::MusicElements::Timing
    end

  end
end