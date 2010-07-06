require File.dirname(__FILE__) + '/../spec_helper'

describe "controller changes" do

  it "should parse elements as controller changes" do
    pattern = Stretto::Pattern.new("X[VOLUME]=1024 C D E X32=800 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::ControllerChange)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::ControllerChange)
  end

  it "should correctly set the controller field" do
    Stretto::Pattern.new("X100=200")[0].controller.should be == 100
  end

  it "should correctly set the value field" do
    Stretto::Pattern.new("X100=200")[0].value.should be == 200
  end

  it "should allow setting of coarse and fine values" # Not a priority for the moment

  it "should allow notes in constant notation"
  
end