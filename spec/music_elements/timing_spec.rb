require File.dirname(__FILE__) + '/../spec_helper'

describe "timing information" do

  it "should be parsed as a timing object from a pattern" do
    pattern = Stretto::Pattern.new("@1000 C D E @2000 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::Timing)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::Timing)
  end

  it "should return value correctly" do
    Stretto::Pattern.new("@1000")[0].value.should be == 1000
  end

  it "should return value correctly when specified in constant notation"

end