require 'midiator'

module Stretto
  class Player

    # TODO: construct a Tempo element with default as first Music Element
    DEFAULT_BPM = 120
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
    end

    # proof of concept.
    # assumes each object is note object.
    # TODO: channels
    def play
      @stretto.each do |note|
        duration = 60.0 / DEFAULT_BPM * note.duration * DEFAULT_BEAT
        @midi.note_on(note.pitch, 0, note.attack)
        sleep duration
        @midi.note_off(note.pitch, 0, note.decay)
      end
    end
  end
end

