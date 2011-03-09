require '../lib/stretto'

player = Stretto::MIDIator::Player.new('C C G G | A A Gh | F F E E | D D Ch', :driver => 'dls_synth')
player.play