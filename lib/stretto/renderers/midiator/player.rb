module Stretto

  class Player
    attr_reader :midi
    attr_accessor :bpm

    #TODO: can time signature be set?
    DEFAULT_BEAT = 4 # each beat is a quarter note

    def initialize(music_string_or_file, opts = {:driver => :autodetect})
      @midi = ::MIDIator::Interface.new
      if opts[:driver] == :autodetect
        @midi.autodetect_driver
      else
        # TODO: exceptions for unhandled drivers
        @midi.use opts[:driver]
      end

      @pattern = Stretto::Pattern.new(music_string_or_file)
      set_default_tempo
    end

    def play
      set_tempo

      voice_threads = []
      @pattern.voices.each_pair do |voice, elements|
        voice_threads << Thread.new(voice, elements) { |v, els| els.each { |e| play_element(e, v) } }
      end
      voice_threads.each { |t| t.join}
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
        when Stretto::MusicElements::Measure, Stretto::MusicElements::Variable
          # noop
        when Stretto::MusicElements::Tempo
          play_tempo(element)
        when Stretto::MusicElements::Harmony
          play_harmony(element, channel)
        when Stretto::MusicElements::ChannelPressure
          play_channel_pressure(element, channel)
        when Stretto::MusicElements::Instrument
          play_instrument(element, channel)
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

    def set_default_tempo
      unless @pattern.first.is_a?(Stretto::MusicElements::Tempo)
        @pattern.unshift(Stretto::MusicElements::Tempo.new("T[Allegro]"))
      end
    end

    def set_tempo
      play_element(@pattern.first)
    end

    def play_instrument(instrument, channel)
      @midi.program_change(channel, instrument.value)
    end

  end
end

