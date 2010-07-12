require File.dirname(__FILE__) + '/../spec_helper'

describe "notes in a chord harmony" do

  it "should return the correct type of music element" do
    Stretto::Pattern.new("C+D+E").first.should be_an_instance_of(Stretto::MusicElements::HarmonicChord)
  end

  it "should parse each harmony as a single element" do
    Stretto::Pattern.new("C+D+E").should have(1).element
    Stretto::Pattern.new("Cmaj+Emin").should have(1).element
    Stretto::Pattern.new("C+D+E Cmaj+Emin").should have(2).elements
  end

  context "when behaving as a chord" do
    it "should be a chord when it doesn't include melody elements" do
      Stretto::Pattern.new("C+D+E").first.should be_kind_of(Stretto::MusicElements::Chord)
    end

    it "should not be a chord if it has melodic elements" do
      Stretto::Pattern.new("C+D+E_F").first.should_not be_kind_of(Stretto::MusicElements::Chord)
    end

    it "should not be a chord if it has rests" do
      Stretto::Pattern.new("C+D+R").first.should_not be_kind_of(Stretto::MusicElements::Chord)
    end

    context "when accessing its duration" do
      it "should return the duration of its elements when they are the same" do
        Stretto::Pattern.new("C+D+E").first.duration.should be == 0.25
        Stretto::Pattern.new("Ch+Dh+Eh").first.duration.should be == 0.5
        Stretto::Pattern.new("C5majw+E5minw").first.duration.should be == 1.0
      end

      it "should return the duration of the longest of its elements when they are different" do
        Stretto::Pattern.new("Cw+Dq+Eh").first.duration.should be == 1.0
        Stretto::Pattern.new("Ch+Dw+Eq").first.duration.should be == 1.0
        Stretto::Pattern.new("Cq+Dh+Ew").first.duration.should be == 1.0
        Stretto::Pattern.new("Cmaj/0.5+Dmin/1.0").first.duration.should be == 1.0
      end

      it "should return duration of elements individually" do
        Stretto::Pattern.new("Cw+Dq+Eh").first.notes.map(&:duration).should be == [1.0, 0.25, 0.5]
        Stretto::Pattern.new("Ch+Dw+Eq").first.notes.map(&:duration).should be == [0.5, 1.0, 0.25]
        Stretto::Pattern.new("Cq+Dh+Ew").first.notes.map(&:duration).should be == [0.25, 0.5, 1.0]
        Stretto::Pattern.new("Cmajw+Dminh").first.notes.map(&:duration).should be == [1.0, 1.0, 1.0, 0.5, 0.5, 0.5]
      end
    end

    context "when accessing its elements" do
      it "should respond to the 'elements' method, and return an array" do
        chord = Stretto::Pattern.new("C+D+E").first
        chord.should respond_to(:elements)
        chord.elements.should_not be_nil
      end

      it "should respond to the 'notes' method, and return an array" do
        chord = Stretto::Pattern.new("C+D+E").first
        chord.should respond_to(:notes)
        chord.elements.should_not be_nil
      end

      it "should return its notes as elements" do
        chord = Stretto::Pattern.new("C+D+E").first
        chord.elements.should == chord.notes
      end

      it "should have only notes as elements" do
        Stretto::Pattern.new("C+D+E").first.notes.all?{|element| element.should be_an_instance_of(Stretto::MusicElements::Note)}
        Stretto::Pattern.new("Cmaj+Dmin").first.notes.all?{|element| element.should be_an_instance_of(Stretto::MusicElements::Note)}
      end

      it "should return the correct number of notes" do
        Stretto::Pattern.new("A+B+C+D+E+F+G").first.should have(7).notes
        Stretto::Pattern.new("C3maj+E5maj").first.should have(6).notes
      end

      it "should filter out repeated notes" do
        chord = Stretto::Pattern.new("C+D##+E+Fb").first
        chord.should have(2).notes
        chord.notes.map(&:pitch).should be == [60, 64]
      end

      it "should keep the first note when they are repeated on the same chord" do
        chord = Stretto::Pattern.new("C+D##+E+Fb").first
        chord.notes.map(&:original_string).should be == ["C", "D##"]
      end

      it "should accept notes in numeric form" do
        chord = Stretto::Pattern.new("[60]h+[61]h+[62]h").first
        chord.should be_kind_of(Stretto::MusicElements::Chord)
        chord.should have(3).notes
      end

      it "should not exceed the range for notes" do
        lambda{ Stretto::Pattern.new("A10+C5") }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
      end
    end
  end

end