module Stretto
  module MusicElements

    class Note
      def initialize(constructor_string, value = nil, accidental = nil, octave = nil)
        @music_string = constructor_string
      end
    end
    
  end
end