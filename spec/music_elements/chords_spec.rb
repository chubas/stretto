require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building chords" do

  context "parsing chords or sequences of chords" do
    it "should return the correct number and kind of chords with one chord" do
      chords = Stretto::Parser.new("Cmaj7").to_stretto
      chords.should have(1).chords
      chords[0].should be_an_instance_of Stretto::MusicElements::Chord
    end

    it "should return the correct number and kind of notes with several chords" do
      chords = Stretto::Parser.new("Cmaj Dmaj").to_stretto
      chords.should have(2).chords
      chords.each{|chord| chord.should be_an_instance_of Stretto::MusicElements::Chord }
    end
  end

  context "parsing standard named chords" do
    it "should have the correct number of notes" do
      Stretto::Parser.new("Cmaj").to_stretto.first.notes.should have(3).notes
      Stretto::Parser.new("Cmin").to_stretto.first.notes.should have(3).notes
      Stretto::Parser.new("Caug").to_stretto.first.notes.should have(3).notes
      Stretto::Parser.new("Cdim").to_stretto.first.notes.should have(3).notes
      Stretto::Parser.new("Cdom7").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cmaj7").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cmin7").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Csus4").to_stretto.first.notes.should have(3).notes
      Stretto::Parser.new("Csus2").to_stretto.first.notes.should have(3).notes
      Stretto::Parser.new("Cmaj6").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cmin6").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cdom9").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cmaj9").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cmin9").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cdim7").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cadd9").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cmin11").to_stretto.first.notes.should have(6).notes
      Stretto::Parser.new("Cdom11").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cdom13").to_stretto.first.notes.should have(6).notes
      Stretto::Parser.new("Cmin13").to_stretto.first.notes.should have(6).notes
      Stretto::Parser.new("Cmaj13").to_stretto.first.notes.should have(6).notes
      Stretto::Parser.new("Cdom7<5").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cdom7>5").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cmaj7<5").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cmaj7>5").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cminmaj7").to_stretto.first.notes.should have(4).notes
      Stretto::Parser.new("Cdom7<5<9").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cdom7<5>9").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cdom7>5<9").to_stretto.first.notes.should have(5).notes
      Stretto::Parser.new("Cdom7>5>9").to_stretto.first.notes.should have(5).notes
    end

    it "should build correctly the interval of notes" do
      maj_chord = Stretto::Parser.new("C#5maj").to_stretto.first
      maj_chord.notes.map(&:value).should be == [61, 65, 68]

      dom_chord = Stretto::Parser.new("C#5dom7>5>9").to_stretto.first
      dom_chord.notes.map(&:value).should be == [61, 65, 69, 71, 76]
    end

    it "should not allow a chord that goes beyond the allowed max values for notes" do
      lambda { Stretto::Parser.new("C10maj").to_stretto }.should_not raise_error # C E G, last value is 127
      lambda { Stretto::Parser.new("F10maj").to_stretto }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
    end

    it "should correctly parse the base note" do
      note  = Stretto::Parser.new("C#5").to_stretto.first
      chord = Stretto::Parser.new("C#5min").to_stretto.first

      note.should == chord.base_note
    end

  end

  context "when building chord inversions" do
    
    it "should return the number of invertions" do
      chord = Stretto::Parser.new("Cmaj").to_stretto.first
      chord.inversions.should == 0

      chord = Stretto::Parser.new("Cmaj^").to_stretto.first
      chord.inversions.should == 1

      chord = Stretto::Parser.new("Cmaj^^").to_stretto.first
      chord.inversions.should == 2
    end

    it "should not allow more inversions that one less than notes there are" do
      lambda{ Stretto::Parser.new("Cmaj^^").to_stretto }.should_not raise_error
      lambda{ Stretto::Parser.new("Cmaj^^^").to_stretto }.should raise_error(Stretto::Exceptions::ChordInversionsException)
    end

    it "should adjust the notes according to the chord invertion"

    it "should specify the pivot note when doing a chord inversion by note"

    it "should not allow to do a chord inversion if the note is not present"

    it "should not allow chord inversions when the value of the inverted note goes beyond allowed value"
  end

  context "when specifying duration" do
    it "should set the same duration for all notes of the chord"
  end

end