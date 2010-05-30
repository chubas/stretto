require File.join(File.dirname(__FILE__), '../spec_helper')

describe 'parsing the whole composition' do

  context "an empty composition" do
    it "should parse an empty composition" do
      Stretto::Parser.new("").should be_valid
    end
  end

  context "allowing multiple space characters" do
    it "should parse music string with whitespace" do
      Stretto::Parser.new("C        D").should be_valid
      Stretto::Parser.new("    C D").should be_valid
      Stretto::Parser.new("C D    ").should be_valid
      Stretto::Parser.new("C\tD").should be_valid
      Stretto::Parser.new("C\nD").should be_valid
      Stretto::Parser.new(<<-STRETTO_STRING).should be_valid
      V0 E5s D#5s | E5s D#5s E5s B4s D5s C5s
      V1 Ri       | Riii
      STRETTO_STRING
    end
  end

end