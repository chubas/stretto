require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing rests" do

  context "reading rests" do
    it "should parse a rest" do
      Stretto::Parser.new("R").should be_valid
    end

    it "should parse a sequence of rests" do
      Stretto::Parser.new("R R").should be_valid
    end
  end

  context "parsing rest modifiers" do
    it "should allow duration modifier" do
      Stretto::Parser.new("Rw").should be_valid
      Stretto::Parser.new("R/3.0").should be_valid
      Stretto::Parser.new("Ri*3:4").should be_valid
    end

    it "should not accept accidentals" do
      Stretto::Parser.new("R#").should_not be_valid
      Stretto::Parser.new("Rb").should_not be_valid
      Stretto::Parser.new("R##").should_not be_valid
      Stretto::Parser.new("Rbb").should_not be_valid
      Stretto::Parser.new("Rn").should_not be_valid
    end

    it "should not allow octaves" do
      Stretto::Parser.new("R7").should_not be_valid
    end

    it "should not accept attack nor decay velocities" do
      Stretto::Parser.new("Ra100").should_not be_valid
      Stretto::Parser.new("Rd100").should_not be_valid
      Stretto::Parser.new("Ra100d100").should_not be_valid
    end
  end

end