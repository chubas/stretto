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
  end

end