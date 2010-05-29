require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing ties" do

  context "reading ties" do
    it "should parse a note with a starting tie" do
      Stretto::Parser.new("Cw-").should be_valid
      Stretto::Parser.new("Cwq.-").should be_valid
      Stretto::Parser.new("Ci*3:4-").should be_valid
    end

    it "should parse a note with an ending tie" do
      Stretto::Parser.new("C-w").should be_valid
      Stretto::Parser.new("C-wq.").should be_valid
      Stretto::Parser.new("C-i*3:4").should be_valid
    end

    it "should parse a note containing both starting and ending ties" do
      Stretto::Parser.new("C-w-").should be_valid
      Stretto::Parser.new("C-wq.-").should be_valid
      Stretto::Parser.new("C-i*3:4-").should be_valid
    end
  end

end