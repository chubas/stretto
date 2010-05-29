require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing accidentals" do

  context "reading sharp, flats and natural accidentals" do

    it "should parse notes with sharp accidentals" do
      Stretto::Parser.new("A#").should be_valid
    end

    it "should parse notes with flat accidentals" do
      Stretto::Parser.new("Ab").should be_valid
    end

    it "should parse notes with double sharp accidentals" do
      Stretto::Parser.new("A##").should be_valid
    end

    it "should parse notes with double flat accidentals" do
      Stretto::Parser.new("Abb").should be_valid
    end

    it "should parse notes with naturals" do
      Stretto::Parser.new("An").should be_valid
    end

  end

end
