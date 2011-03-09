require File.dirname(__FILE__) + '/../lib/stretto'

file = File.new(File.dirname(__FILE__) + '/entertainer.jfugue')
player = Stretto::MIDIator::Player.new(file, :driver => :autodetect)
player.play