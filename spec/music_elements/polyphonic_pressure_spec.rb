require File.dirname(__FILE__) + '/../spec_helper'

describe "polyphonic pressure" do

  it "should parse polyphonic pressure elements in pattern" do
    pattern = Stretto::Pattern.new("*60,10 C D E *67,80 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::PolyphonicPressure)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::PolyphonicPressure)
  end

  it "should not allow a value higher that 127 in its pitch value" do
    lambda{ Stretto::Pattern.new("*127,80") }.should_not raise_error
    lambda{ Stretto::Pattern.new("*128,80") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /pitch value/i)
  end

  it "should not allow a value higher that 127 for its value" do
    lambda{ Stretto::Pattern.new("*80,127") }.should_not raise_error
    lambda{ Stretto::Pattern.new("*80,128") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /value/i)
  end

  it "should return its pitch correctly" do
    Stretto::Pattern.new("*80,100")[0].pitch.should be == 80
  end

  it "should return its value correctly" do
    Stretto::Pattern.new("*80,100")[0].value.should be == 100
  end

  it "should return its variable correctly when using variable notation" do
    elements = Stretto::Pattern.new("$MY_PITCH=80 $MY_VALUE=100 *[MY_PITCH],60 *60,[MY_VALUE] *[MY_PITCH],[MY_VALUE]")
    elements[2].pitch.should be == 80
    elements[2].value.should be == 60

    elements[3].pitch.should be == 60
    elements[3].value.should be == 100

    elements[4].pitch.should be == 80
    elements[4].value.should be == 100
  end

end