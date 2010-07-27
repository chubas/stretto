module Stretto
  module MusicElements

    class Chord < MusicElement

      # The literal names of chord intervals.
      # Values represent the semitones from the base note of the notes that form the chord.
      CHORD_INTERVALS = {
        'maj'       => [4, 7],
        'min'       => [3, 7],
        'aug'       => [4, 8],
        'dim'       => [3, 6],
        'dom7'      => [4, 7, 10],
        'maj7'      => [4, 7, 11],
        'min7'      => [3, 7, 10],
        'sus4'      => [5, 7],
        'sus2'      => [2, 7],
        'maj6'      => [4, 7, 9],
        'min6'      => [3, 7, 9],
        'dom9'      => [4, 7, 10, 14],
        'maj9'      => [4, 7, 11, 14],
        'min9'      => [3, 7, 10, 14],
        'dim7'      => [3, 6, 9],
        'add9'      => [4, 7, 14],
        'min11'     => [7, 10, 14, 15, 17],
        'dom11'     => [7, 10, 14, 17],
        'dom13'     => [7, 10, 14, 16, 21],
        'min13'     => [7, 10, 14, 15, 21],
        'maj13'     => [7, 11, 14, 16, 21],
        'dom7<5'    => [4, 6, 10],
        'dom7>5'    => [4, 8, 10],
        'maj7<5'    => [4, 6, 11],
        'maj7>5'    => [4, 8, 11],
        'minmaj7'   => [3, 7, 11],
        'dom7<5<9'  => [4, 6, 10, 13],
        'dom7<5>9'  => [4, 6, 10, 15],
        'dom7>5<9'  => [4, 8, 10, 13],
        'dom7>5>9'  => [4, 8, 10, 15]
      }
      
    end

  end
end