require File.dirname(__FILE__) + '/../spec_helper'

describe "controller changes" do

  it "should parse elements as controller changes" do
    pattern = Stretto::Pattern.new("$VOLUME=100 X[VOLUME]=1024 C D E X32=800 F G A")
    pattern[1].should be_an_instance_of(Stretto::MusicElements::ControllerChange)
    pattern[5].should be_an_instance_of(Stretto::MusicElements::ControllerChange)
  end

  it "should correctly set the controller field" do
    Stretto::Pattern.new("X100=200")[0].controller.should be == 100
  end

  it "should correctly set the value field" do
    Stretto::Pattern.new("X100=200")[0].value.should be == 200
  end

  it "should allow setting of coarse and fine values" # Not a priority for the moment

  it "should allow notes in variable notation" do
    pattern = Stretto::Pattern.new(
        "$MY_CONTROLLER=80 $MY_VALUE=100 X[MY_CONTROLLER]=60 X60=[MY_VALUE] X[MY_CONTROLLER]=[MY_VALUE]"
    )
    pattern[2].controller.should be == 80
    pattern[2].value.should be == 60
    pattern[3].controller.should be == 60
    pattern[3].value.should be == 100
    pattern[4].controller.should be == 80
    pattern[4].value.should be == 100

  end
  
end