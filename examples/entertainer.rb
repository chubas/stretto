require File.dirname(__FILE__) + '/../lib/stretto'

file = File.new(File.dirname(__FILE__) + '/entertainer.jfugue')
player = Stretto::Player.new
player.play(file)