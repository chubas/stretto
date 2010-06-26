require File.join(File.dirname(__FILE__), '/../spec_helper')

describe "melodies" do

  it "should parse correctly melodies as different tokens" do
    Stretto::Pattern.new("A_B C_D E_F").should have(3).elements
  end

  it "should parse correctly the melody type" do
    Stretto::Pattern.new("C_D_E").first.should be_an_instance_of(Stretto::MusicElements::Melody)
  end

  it "should parse melodies as part of harmonies" do
    harmony = Stretto::Pattern.new("C_D+E_F").first
    harmony.should be_an_instance_of(Stretto::MusicElements::Harmony)
    harmony.elements.each { |melody| melody.should be_an_instance_of(Stretto::MusicElements::Melody) }
  end

  context "when accessing its elements" do
    it "should respond to :elements" do
      melody = Stretto::Pattern.new("C_D_E").first
      melody.should respond_to(:elements)
      melody.elements.should_not be_nil
    end

    it "should return the correct number of elements in the melody" do
      Stretto::Pattern.new("C_Dmaj_R_Emin7_F").first.should have(5).elements
    end

    it "should return the correct type of elements" do
      elements = Stretto::Pattern.new("C_Dmaj_R_Emin7_F").first.elements
      elements[0].should be_an_instance_of Stretto::MusicElements::Note
      elements[1].should be_an_instance_of Stretto::MusicElements::Chord
      elements[2].should be_an_instance_of Stretto::MusicElements::Rest
      elements[3].should be_an_instance_of Stretto::MusicElements::Chord
      elements[4].should be_an_instance_of Stretto::MusicElements::Note
    end
  end

  context "when accessing its duration" do
    it "should return the sum of the total duration of its elements" do
      Stretto::Pattern.new("Ch_Dh_Ew"      ).first.duration.should be == 2.0
      Stretto::Pattern.new("Cmin7w._Emajh" ).first.duration.should be == 2.0
      Stretto::Pattern.new("Rh_Rh_Rh_Rh"   ).first.duration.should be == 2.0
      Stretto::Pattern.new("C5h._Dmajh._Rh").first.duration.should be == 2.0
    end
  end

end