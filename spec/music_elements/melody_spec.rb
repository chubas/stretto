require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Melody do

  context "initializing as a collection of elements" do

    it "should receive at least one element to be constructed" do
      lambda { Stretto::MusicElements::Melody.new }.should raise_error(ArgumentError)
      lambda { Stretto::MusicElements::Melody.new(nil) }.should raise_error(ArgumentError)
      lambda { Stretto::MusicElements::Melody.new([]) }.should raise_error(ArgumentError)
    end

    it "should only accept MusicElement elements, as an array or a single element" do
      lambda { Stretto::MusicElements::Melody.new([1, 2, 3]) }.should raise_error(ArgumentError)
      lambda do
        Stretto::MusicElements::Melody.new(Stretto::MusicElements::Note.new("C5"))
      end.should_not raise_error
      lambda do
        Stretto::MusicElements::Melody.new(
            [Stretto::MusicElements::Note.new("C5"), Stretto::MusicElements::Note.new("C6")]
        )
      end.should_not raise_error()
    end

    it "should not accept multiple elements as different arguments, and treat second parameter as the pattern" do
      lambda do
        Stretto::MusicElements::Melody.new(
            Stretto::MusicElements::Note.new("C5"), Stretto::MusicElements::Note.new("C5")
        )
      end.should raise_error(ArgumentError)
      lambda do
        Stretto::MusicElements::Melody.new(Stretto::MusicElements::Note.new("C5"), nil)
      end.should_not raise_error()
    end

    it "should preserve the order of elements" do
      melody = Stretto::MusicElements::Melody.new(
          [Stretto::MusicElements::Note.new("C5"), Stretto::MusicElements::Rest.new("R")]
      )
      melody.elements[0].should be_instance_of(Stretto::MusicElements::Note)
      melody.elements[1].should be_instance_of(Stretto::MusicElements::Rest)
    end

    it "should accept additional elements" do
      melody = Stretto::MusicElements::Melody.new([Stretto::MusicElements::Note.new("C5")])
      melody.should respond_to(:<<)
      melody << Stretto::MusicElements::Rest.new("R")
      melody.should have(2).elements
      melody.elements[1].should be_an_instance_of(Stretto::MusicElements::Rest)
    end

    it "should correctly bind pattern to element when it is attached to a melody" do
      melody = Stretto::Pattern.new("$MY_VAR=80 C_D_E")[1]
      note = Stretto::MusicElements::Note.new("[MY_VAR]w")
      melody << note
      note.pitch.should be == 80
    end
    
    # Possible future development: Accept a music string (Stretto::MusicElements::Melody.new("C D E"))
    
  end

end