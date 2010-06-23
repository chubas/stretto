require File.dirname(__FILE__) + '/../spec_helper'

describe "notes in harmony (but not chords)" do

  it "should be a harmony" do
    Stretto::Pattern.new("Cw+Dh_Eh").first.should be_kind_of(Stretto::MusicElements::Harmony)
  end

  # but...
  it "should not be a chord" do
    Stretto::Pattern.new("Cw+Dh_Eh").first.should_not be_kind_of(Stretto::MusicElements::Chord)
    Stretto::Pattern.new("Cw+Dh_Eh").first.should_not be_kind_of(Stretto::MusicElements::HarmonicChord)
  end

  it "should be a harmony when any note in a chord is a rest" do
    Stretto::Pattern.new("C+D+R").first.should be_kind_of(Stretto::MusicElements::Harmony)
  end
  
  context "when accessing its duration" do
    it "should return the duration of the longest of its elements when it is a single element" do
      Stretto::Pattern.new("Cw+Dq_Eq").first.duration.should be == 1.0
      Stretto::Pattern.new("Dq_Eq+Rw").first.duration.should be == 1.0
      Stretto::Pattern.new("Dq+Eq+Rw").first.duration.should be == 1.0
      Stretto::Pattern.new("Ch_Dh"   ).first.duration.should be == 1.0
      Stretto::Pattern.new("Ch_Dminh").first.duration.should be == 1.0
    end

    it "should return the duration of the longest of its elements when it is a melody" do
      Stretto::Pattern.new("Cq+Dh_Eh").first.duration.should be == 1.0
      Stretto::Pattern.new("Ch_Rh+Rh").first.duration.should be == 1.0
      Stretto::Pattern.new("C+Dh._Eq").first.duration.should be == 1.0
    end
  end

  context "when accessing its elements" do
    it "should respond to the 'elements' method" do
      harmony = Stretto::Pattern.new("C+D_E").first
      harmony.should respond_to(:elements)
      harmony.elements.should_not be_nil
    end

    it "should not respond to the 'notes' method" do
      harmony = Stretto::Pattern.new("C+D_E").first
      harmony.should_not respond_to(:notes)
    end

    it "should return the correct number of elements" do
      Stretto::Pattern.new("C+D+R").first.should have(3).elements
      Stretto::Pattern.new("Cmaj+R+Dmin").first.should have(3).elements
      Stretto::Pattern.new("C+D_E").first.should have(2).elements
      Stretto::Pattern.new("C_D+E").first.should have(2).elements
      Stretto::Pattern.new("C_D_E").first.should have(1).elements
    end

    it "should return correct type of elements" do
      elements = Stretto::Pattern.new("C+D_E+Fmin+R+Cmin_R").first.elements
      elements[0].should be_an_instance_of(Stretto::MusicElements::Note)
      elements[1].should be_an_instance_of(Stretto::MusicElements::Melody)
      elements[2].should be_an_instance_of(Stretto::MusicElements::Chord)
      elements[3].should be_an_instance_of(Stretto::MusicElements::Rest)
      elements[4].should be_an_instance_of(Stretto::MusicElements::Melody)
    end
  end

end