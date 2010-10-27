require 'midiator'

module Stretto

  class Player
    attr_reader :midi
    attr_accessor :bpm, :channel
    
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
      @channel = 0
      set_default_tempo
    end

    def play
      @stretto.each do |element|
        if !element.respond_to?(:play)
          raise "element of type #{element.class} not yet handled by player"
        else
          element.play(self)
        end
      end
    end

    def default_beat
      DEFAULT_BEAT
    end
    
    private

    def set_default_tempo
      unless @stretto.first.is_a?(Stretto::MusicElements::Tempo)
        @stretto.unshift(Stretto::MusicElements::Tempo.new("T[Allegro]"))
      end
    end
  end
  
end

