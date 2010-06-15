require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building rests" do

  context "parsing rests" do

    it "should instantiate rests with the correct type" do
      Stretto::Parser.new("R").to_stretto.first.should be_instance_of(Stretto::MusicElements::Rest)
      Stretto::Parser.new("Rw").to_stretto.first.should be_instance_of(Stretto::MusicElements::Rest)
      Stretto::Parser.new("R/0.5").to_stretto.first.should be_instance_of(Stretto::MusicElements::Rest)
    end

    it "should parse duration" do
      rest = Stretto::Parser.new("Rw").to_stretto.first
      rest.original_duration.should be == 'w'
      rest.duration.should          be == 1.0
    end
    
  end

end