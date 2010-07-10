require File.dirname(__FILE__) + '/../spec_helper'

describe "channel presure" do

  it "should return channel pressure elements from a pattern" do
    pattern = Stretto::Pattern.new("+10 C D E +80 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::ChannelPressure)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::ChannelPressure)
  end

  it "should not accept values above 127" do
    lambda{ Stretto::Pattern.new("+127") }.should_not raise_error
    lambda{ Stretto::Pattern.new("+128") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /channel pressure/i)
  end

  it "should return its value correctly" do
    channel_pressures = Stretto::Pattern.new("+40 +120")
    channel_pressures[0].value.should be == 40
    channel_pressures[1].value.should be == 120
  end

  it "should return correct value when given as a variable value" do
    Stretto::Pattern.new("$MY_VAR=80 &[MY_VAR]")[1].value.should be == 80
  end
  
end