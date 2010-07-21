require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Harmony do

  context "when creating it from its string representation" do
    it "should return its elements correctly" do
      Stretto::MusicElements::Harmony.new("C+R+Dmaj").should have(3).elements
    end

    it "should respect the order of its elements" do
      harmony = Stretto::MusicElements::Harmony.new("C+R+Dmaj")
      harmony.elements[0].should be_an_instance_of(Stretto::MusicElements::Note)
      harmony.elements[1].should be_an_instance_of(Stretto::MusicElements::Rest)
      harmony.elements[2].should be_an_instance_of(Stretto::MusicElements::Chord)
    end

    it "should return the duration of the longest element" do
      Stretto::MusicElements::Harmony.new("C+R+Dmajw").duration.should be == 1.0
    end

    it "should raise error on elements when a variable is not present" do
      harmony = Stretto::MusicElements::Harmony.new("C+R+[MY_VAR]maj")
      lambda do
        harmony.elements[2].base_note.pitch
      end.should raise_error(Stretto::Exceptions::VariableContextException, /MY_VAR/)
    end

    it "should not raise error with predefined variables" do
      harmony = Stretto::MusicElements::Harmony.new("C+R+[PIANO]maj")
      harmony.elements[2].base_note.pitch.should be == 0
    end

    it "should get the variable value from a pattern when attached" do
      harmony = Stretto::MusicElements::Harmony.new("C+R+[MY_VAR]maj")
      pattern = Stretto::Pattern.new("$MY_VAR=80")
      pattern << harmony
      harmony.elements[2].base_note.pitch.should be == 80
    end

    ALL_ELEMENTS.except(:harmony, :harmonic_chord).each do |element, string|
      it "should not parse #{element} as a harmony" do
        lambda do
          Stretto::MusicElements::Harmony.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /harmony/i)
      end
    end
  end

end