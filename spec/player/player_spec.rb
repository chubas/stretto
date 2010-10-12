require File.join(File.dirname(__FILE__), '../spec_helper')

describe "player" do

  context "plays a single note" do
    it "with the correct pitch" do
      # TODO: using mac only driver!
      player = Stretto::Player.new("C", :driver => :dls_synth)

      midi = player.instance_variable_get("@midi")
      midi.should_receive(:note_on).with(60, anything, anything)
      midi.should_receive(:note_off).with(60, anything, anything)
      
      player.play
    end

    it "with the correct default attack and decay" do
      player = Stretto::Player.new("C", :driver => :dls_synth)

      midi = player.instance_variable_get("@midi")
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)
      
      player.play
    end

    it "with different attack and decay values" do
      player = Stretto::Player.new("Ca80d30", :driver => :dls_synth)

      midi = player.instance_variable_get("@midi")
      midi.should_receive(:note_on).with(anything, anything, 80)
      midi.should_receive(:note_off).with(anything, anything, 30)
      
      player.play
    end
    
  end
  
end
