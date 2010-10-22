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
      @channel = 0
      set_default_tempo
    end

    def play
      @stretto.each do |element|
        case element
        when Stretto::MusicElements::Tempo
          @bpm = element.bpm
        when Stretto::MusicElements::Note
          if !((element.start_of_tie? && element.end_of_tie?) || element.end_of_tie?)
            # puts "tied duration: #{element.tied_duration}"
            duration = 60.0 / @bpm * element.tied_duration * DEFAULT_BEAT
            @midi.note_on(element.pitch, @channel, element.attack)
            @midi.rest(duration)
            @midi.note_off(element.pitch, @channel, element.decay)
          end
        when Stretto::MusicElements::VoiceChange
          @channel = element.index
        # TODO: handle ties
        when Stretto::MusicElements::Chord
          duration = 60.0 / @bpm * element.duration * DEFAULT_BEAT
          element.notes.each do |note|
            @midi.note_on(note.pitch, @channel, element.attack)
          end
          @midi.rest(duration)
          element.notes.each do |note|
            @midi.note_off(note.pitch, @channel, element.decay)
          end
        when Stretto::MusicElements::Measure
          # noop
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

