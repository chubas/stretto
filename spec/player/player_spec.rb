require File.join(File.dirname(__FILE__), '../spec_helper')

describe "player" do
  
  it "plays a single note with the correct pitch, duration, channel, and attack" do
    # TODO: using mac only driver!
    player = Stretto::Player.new("C", :driver => :dls_synth)

    midi = player.instance_variable_get("@midi")
    midi.should_receive(:play).with(60, 0.5, 0, 64)
    
    player.play
  end
  
end
