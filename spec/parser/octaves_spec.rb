require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing octaves" do

  context "reading octaves" do

    it "should parse notes with octaves" do
      0.upto(10) do |octave|
        Stretto::Parser.new("C" + octave.to_s).should be_valid
      end
    end

    it "should parse chords with octaves" do
      0.upto(10) do |octave|
        Stretto::Parser.new("C" + octave.to_s + "maj").should be_valid
      end
    end

    it "should parse notes with accidentals" do
      Stretto::Parser.new("Cb5").should be_valid
    end

    #NOTE: Not sure if this should be validated from the beggining
    it "should allow any value fot a chord in the lexical analysis phase" do
      Stretto::Parser.new("Cb-1").should be_valid
      Stretto::Parser.new("Cb11").should be_valid
    end

  end

end