module Stretto

  # Stretto default Player uses MIDIator for MIDI output.
  class Player
    attr_reader :midi
    attr_accessor :bpm

    #TODO: can time signature be set?
    DEFAULT_BEAT = 4 # each beat is a quarter note

    # @param options [Hash] An array of options to initialize the MIDI driver
    #   Pass `:driver => :autodetect` to let MIDIator select the most appropiate driver based on the OS
    # @example
    #   Stretto::Player.new(:driver => :dls_synth)
    def initialize(options = {:driver => :autodetect})
      @midi = ::MIDIator::Interface.new
      if options[:driver] == :autodetect
        @midi.autodetect_driver
      else
        # TODO: exceptions for unhandled drivers
        @midi.use options[:driver]
      end
    end

    # Plays the passed music string (or a File object containing a music string)
    #
    # @param music_string_or_file [String, File] The stretto music string
    # @example
    #   Stretto::Player.new.play("C D E F G A B C6")
    #
    def play(music_string_or_file)
      @pattern = Stretto::Pattern.new(music_string_or_file)

      set_default_tempo
      layer_threads = []
      @pattern.voices.each_value do |voice|
        voice.layers.each_value do |layer|
          layer_threads << Thread.new(layer) do |l|
            l.each { |e| play_element(e, voice.index) }
          end

        end
      end
      layer_threads.each { |t| t.join}
    end

   private

    def play_element(element, channel = 0)
      case element
        when Stretto::MusicElements::Note
          play_note(element, channel)
        when Stretto::MusicElements::Rest
          play_rest(element)
        when Stretto::MusicElements::Chord
          play_chord(element, channel)
        when Stretto::MusicElements::Melody
          play_melody(element, channel)
        when Stretto::MusicElements::Measure
          play_measure(element)
        when Stretto::MusicElements::Variable
          play_variable(element)
        when Stretto::MusicElements::VoiceChange
          play_voice_change(element)
        when Stretto::MusicElements::LayerChange
          play_layer_change(element)
        when Stretto::MusicElements::KeySignature
          play_key_signature(element)
        when Stretto::MusicElements::Tempo
          play_tempo(element)
        when Stretto::MusicElements::Harmony
          play_harmony(element, channel)
        when Stretto::MusicElements::ChannelPressure
          play_channel_pressure(element, channel)
        when Stretto::MusicElements::PolyphonicPressure
          play_polyphonic_pressure(element, channel)
        when Stretto::MusicElements::Instrument
          play_instrument(element, channel)
        when Stretto::MusicElements::PitchBend
          play_pitch_bend(element, channel)
        else
          raise "element of class #{element.class} not yet handled by player"
      end
    end

    def play_note(note, channel)
      unless note.end_of_tie?
        duration = 60.0 / bpm * note.tied_duration * DEFAULT_BEAT
        @midi.note_on(note.pitch, channel, note.attack)
        @midi.rest(duration)
        @midi.note_off(note.pitch, channel, note.decay)
      end
    end

    def play_rest(rest)
      unless rest.end_of_tie?
        duration = 60.0 / bpm * rest.tied_duration * DEFAULT_BEAT
        @midi.rest(duration)
      end
    end

    def play_chord(chord, channel)
      unless chord.end_of_tie?
        duration = 60.0 / bpm * chord.tied_duration * DEFAULT_BEAT
        chord.notes.each do |note|
          @midi.note_on(note.pitch, channel, note.attack)
        end
        @midi.rest(duration)
        chord.notes.each do |note|
          @midi.note_off(note.pitch, channel, note.decay)
        end
      end
    end

    def play_melody(melody, channel)
      melody.elements.each do |element|
        case element
        when Stretto::MusicElements::Note
          play_note(element, channel)
        when Stretto::MusicElements::Rest
          play_rest(element)
        when Stretto::MusicElements::Chord
          play_chord(element, channel)
        end
      end
    end

    def play_harmony(harmony, channel)
      harmony_threads = []
      harmony.elements.each do |element|
        harmony_threads << Thread.new(element) { |e| play_element(e, channel) }
      end
      harmony_threads.each { |t| t.join }
    end

    def play_tempo(tempo)
      @bpm = tempo.bpm
    end

    def play_channel_pressure(channel_pressure, channel)
      @midi.channel_aftertouch(channel, channel_pressure.value)
    end

    def play_polyphonic_pressure(polyphonic_pressure, channel)
      @midi.aftertouch(polyphonic_pressure.pitch, channel, polyphonic_pressure.value)
    end

    def set_default_tempo
      unless @pattern.first.is_a?(Stretto::MusicElements::Tempo)
        play_element(Stretto::MusicElements::Tempo.new("T[Allegro]"))
      end
    end

    def play_instrument(instrument, channel)
      @midi.program_change(channel, instrument.value)
    end

    def play_pitch_bend(pitch_bend, channel)
      @midi.pitch_bend(channel, pitch_bend.value)
    end

    def play_key_signature(key_signature)
      # noop
      # TODO, NOTE:
      #   MIDI specification allows for a meta message key-signature event.
      #   While this is useful for some tools, it does not affect the playback.
      # TODO: Add meta-event key signature
    end

    def play_measure(measure)
      # noop
    end

    def play_variable(variable)
      # noop
    end

    def play_voice_change(voice_change)
      # noop
    end

    def play_layer_change(layer_change)
      # noop
    end

  end
end

