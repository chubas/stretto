require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building rests" do

  context "parsing rests" do

    it "should instantiate rests with the correct type" do
      Stretto::Pattern.new("R").first.should be_instance_of(Stretto::MusicElements::Rest)
      Stretto::Pattern.new("Rw").first.should be_instance_of(Stretto::MusicElements::Rest)
      Stretto::Pattern.new("R/0.5").first.should be_instance_of(Stretto::MusicElements::Rest)
    end

    it "should parse duration" do
      rest = Stretto::Pattern.new("Rw").first
      rest.original_duration.should be == 'w'
      rest.duration.should          be == 1.0
    end
    
  end

end