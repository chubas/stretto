require 'midiator'

module Stretto
  class Player

    attr_accessor :stretto

    #TODO: can time signature be set?
    DEFAULT_BEAT = 4 # each beat is a quarter note 
    
    def initialize(music_string, opts = {:driver => :autodetect})
      @midi = MIDIator::Interface.new
      if opts[:driver] == :autodetect
        @midi.autodetect_driver
      else
        # TODO: exceptions for unhandled drivers
        @midi.use opts[:driver]
      end

      @stretto = Stretto::Parser.new(music_string).to_stretto
      set_default_tempo      
    end

    # TODO: channels
    # TODO: properly handle duration (ties, etc)
    def play
      @stretto.each do |element|
        case element
        when Stretto::MusicElements::Tempo
          @bpm = element.bpm
        when Stretto::MusicElements::Note
          note = element
          duration = 60.0 / @bpm * note.duration * DEFAULT_BEAT
          @midi.note_on(note.pitch, 0, note.attack)
          sleep duration
          @midi.note_off(note.pitch, 0, note.decay)
        else
          raise "element of type #{element.class} not yet handled by player"
        end
      end
    end

    private

    def set_default_tempo
      unless @stretto.first.is_a?(Stretto::MusicElements::Tempo)
        @stretto.unshift(Stretto::MusicElements::Tempo.new("T[Allegro]"))
      end
    end
  end
end

