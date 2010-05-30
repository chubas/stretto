require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing notes" do

  context "reading natural notes" do

    it "should parse a note" do
      Stretto::Parser.new("C").should be_valid
    end

    it "should parse a sequence of notes" do
      Stretto::Parser.new("C D E").should be_valid
    end

    it "should parse notes expressed numerically" do
      Stretto::Parser.new("[60]").should be_valid
    end

    it "should parse a sequence of notes expressed numerically" do
      Stretto::Parser.new("[60] [61] [63]").should be_valid
    end

    #NOTE: Not sure if this should be validated from the beggining
    it "should allow notes beyond allowed range in the lexical analysis phase" do
      Stretto::Parser.new("[128]").should be_valid
    end

  end

end