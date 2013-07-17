require File.dirname(__FILE__) + '/../spec_helper'

describe "pitch bend modifier" do
  it "should return an instance of pitch bend" do
    pattern = Stretto::Pattern.new("&0 C D E &8192 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::PitchBend)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::PitchBend)
  end

  it "should not allow values higher than 16383" do
    lambda{ Stretto::Pattern.new("&16383") }.should_not raise_error
    lambda{ Stretto::Pattern.new("&16384") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /pitch bend/i)
  end
  
  it "should return its value correctly" do
    pitch_bends = Stretto::Pattern.new("&0 &8192 &16383")
    pitch_bends[0].value.should be == 0
    pitch_bends[1].value.should be == 8192
    pitch_bends[2].value.should be == 16383
  end

  it "should return value correctly when using a variable value" do
    Stretto::Pattern.new("$MY_VAR=80 &[MY_VAR]")[1].value.should be == 80
  end
end