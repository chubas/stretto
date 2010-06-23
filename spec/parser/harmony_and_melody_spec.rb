require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing harmonies and melodies" do

  context "reading harmonies" do
    it "should parse notes coming in harmony" do
      Stretto::Parser.new("C5+C6+C7").should be_valid
      Stretto::Parser.new("Cmaj+Dmin").should be_valid
      Stretto::Parser.new("C+R+D").should be_valid
    end

    it "should not accept inversions like chords do" do
      Stretto::Parser.new("C5+C6+C7^").should_not be_valid
      Stretto::Parser.new("C5+C6+C7^C5").should_not be_valid
      Stretto::Parser.new("C5+C6+C7^^").should_not be_valid
    end

  end

  context "reading melodies" do
    it "should parse notes coming in melody" do
      Stretto::Parser.new("C5_C6_C7").should be_valid
      Stretto::Parser.new("Cmaj_Dmin").should be_valid
      Stretto::Parser.new("C_R_D").should be_valid
    end
  end

  context "reading notes in harmony and melody" do
    it "should parse notes in harmony and melody together" do
      Stretto::Parser.new("C5w+C6h_C7h").should be_valid
      Stretto::Parser.new("C5h_C6h+C7w").should be_valid
      Stretto::Parser.new("C5_R+C7").should be_valid
      Stretto::Parser.new("C5+R_C7").should be_valid
      Stretto::Parser.new("C5maj_Dmin+E_R_F").should be_valid
      Stretto::Parser.new("A+B+C_D+E+F_Gmin+Amaj").should be_valid
    end
  end

end
