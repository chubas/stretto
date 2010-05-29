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

  context "allowing a rest to have any modifier a single note can have" do
    it "should accept accidentals" do
      Stretto::Parser.new("Rb Rbb R# R## Rn").should be_valid
    end

    it "should allow octaves" do
      Stretto::Parser.new("R0 R6 R10").should be_valid
    end
  end

end