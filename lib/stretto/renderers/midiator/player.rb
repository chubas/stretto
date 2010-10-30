module Stretto
  module MIDIator

    class Player
      attr_reader :midi
      attr_accessor :bpm, :channel

      #TODO: can time signature be set?
      DEFAULT_BEAT = 4 # each beat is a quarter note

      def initialize(music_string, opts = {:driver => :autodetect})
        @midi = ::MIDIator::Interface.new
        if opts[:driver] == :autodetect
          @midi.autodetect_driver
        else
          # TODO: exceptions for unhandled drivers
          @midi.use opts[:driver]
        end

        @stretto = Stretto::Parser.new(music_string).to_stretto
        @channel = 0
        set_default_tempo
      end

      def play
        @stretto.each do |element|
          play_element(element)
        end
      end

      private

      def play_element(element)
        case element
          when Stretto::MusicElements::Note
            play_note(element)
          when Stretto::MusicElements::Rest
            play_rest(element)
          when Stretto::MusicElements::Chord
            play_chord(element)
          when Stretto::MusicElements::Melody
            play_melody(element)
          when Stretto::MusicElements::Measure
            # noop
          when Stretto::MusicElements::Tempo
            play_tempo(element)
          when Stretto::MusicElements::VoiceChange
            play_voice_change(element)
          else
            raise "element of class #{element.class} not yet handled by player"
        end
      end

      def play_note(note)
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

      def play_chord(chord)
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

      def play_melody(melody)
        melody.elements.each do |element|
          case element
          when Stretto::MusicElements::Note
            play_note(element)
          when Stretto::MusicElements::Rest
            play_rest(element)
          when Stretto::MusicElements::Chord
            play_chord(element)
          end
        end
      end

      def play_tempo(tempo)
        @bpm = tempo.bpm
      end

      def play_voice_change(voice_change)
        @channel = voice_change.index
      end

      def set_default_tempo
        unless @stretto.first.is_a?(Stretto::MusicElements::Tempo)
          @stretto.unshift(Stretto::MusicElements::Tempo.new("T[Allegro]"))
        end
      end

    end

  end
end

