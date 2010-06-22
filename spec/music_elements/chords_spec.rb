require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building chords" do

  context "parsing chords or sequences of chords" do
    it "should return the correct number and kind of chords with one chord" do
      chords = Stretto::Pattern.new("Cmaj7")
      chords.should have(1).chords
      chords[0].should be_an_instance_of Stretto::MusicElements::Chord
    end

    it "should return the correct number and kind of notes with several chords" do
      chords = Stretto::Pattern.new("Cmaj Dmaj")
      chords.should have(2).chords
      chords.each{|chord| chord.should be_an_instance_of Stretto::MusicElements::Chord }
    end
  end

  context "parsing standard named chords" do
    it "should have the correct number of notes" do
      Stretto::Pattern.new("Cmaj").first.should have(3).notes
      Stretto::Pattern.new("Cmin").first.should have(3).notes
      Stretto::Pattern.new("Caug").first.should have(3).notes
      Stretto::Pattern.new("Cdim").first.should have(3).notes
      Stretto::Pattern.new("Cdom7").first.should have(4).notes
      Stretto::Pattern.new("Cmaj7").first.should have(4).notes
      Stretto::Pattern.new("Cmin7").first.should have(4).notes
      Stretto::Pattern.new("Csus4").first.should have(3).notes
      Stretto::Pattern.new("Csus2").first.should have(3).notes
      Stretto::Pattern.new("Cmaj6").first.should have(4).notes
      Stretto::Pattern.new("Cmin6").first.should have(4).notes
      Stretto::Pattern.new("Cdom9").first.should have(5).notes
      Stretto::Pattern.new("Cmaj9").first.should have(5).notes
      Stretto::Pattern.new("Cmin9").first.should have(5).notes
      Stretto::Pattern.new("Cdim7").first.should have(4).notes
      Stretto::Pattern.new("Cadd9").first.should have(4).notes
      Stretto::Pattern.new("Cmin11").first.should have(6).notes
      Stretto::Pattern.new("Cdom11").first.should have(5).notes
      Stretto::Pattern.new("Cdom13").first.should have(6).notes
      Stretto::Pattern.new("Cmin13").first.should have(6).notes
      Stretto::Pattern.new("Cmaj13").first.should have(6).notes
      Stretto::Pattern.new("Cdom7<5").first.should have(4).notes
      Stretto::Pattern.new("Cdom7>5").first.should have(4).notes
      Stretto::Pattern.new("Cmaj7<5").first.should have(4).notes
      Stretto::Pattern.new("Cmaj7>5").first.should have(4).notes
      Stretto::Pattern.new("Cminmaj7").first.should have(4).notes
      Stretto::Pattern.new("Cdom7<5<9").first.should have(5).notes
      Stretto::Pattern.new("Cdom7<5>9").first.should have(5).notes
      Stretto::Pattern.new("Cdom7>5<9").first.should have(5).notes
      Stretto::Pattern.new("Cdom7>5>9").first.should have(5).notes
    end

    it "should build correctly the interval of notes" do
      maj_chord = Stretto::Pattern.new("C#5maj").first
      maj_chord.notes.map(&:value).should be == [61, 65, 68]

      dom_chord = Stretto::Pattern.new("C#5dom7>5>9").first
      dom_chord.notes.map(&:value).should be == [61, 65, 69, 71, 76]
    end

    it "should not allow a chord that goes beyond the allowed max values for notes" do
      lambda { Stretto::Pattern.new("C10maj") }.should_not raise_error # C E G, last value is 127
      lambda { Stretto::Pattern.new("F10maj") }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
    end

    it "should correctly parse the base note" do
      note  = Stretto::Pattern.new("C#5").first
      chord = Stretto::Pattern.new("C#5min").first

      note.should == chord.base_note
    end

  end

  context "when building chord inversions" do
    
    it "should return the number of invertions" do
      chord = Stretto::Pattern.new("Cmaj").first
      chord.inversions.should be == 0

      chord = Stretto::Pattern.new("Cmaj^").first
      chord.inversions.should be == 1

      chord = Stretto::Pattern.new("Cmaj^^").first
      chord.inversions.should be == 2
    end

    it "should specify the pivot note when doing a chord inversion by note" do
      chord = Stretto::Pattern.new("Cmaj^E").first
      chord.pivot_note.should_not be_nil
      chord.pivot_note.value.should == 40
    end

    it "should not allow more inversions that one less than notes there are" do
      lambda{ Stretto::Pattern.new("Cmaj^^") }.should_not raise_error
      lambda{ Stretto::Pattern.new("Cmaj^^^") }.should raise_error(Stretto::Exceptions::ChordInversionsException)
    end

    it "should adjust the notes according to the chord invertion when using inversion count" do
      chord = Stretto::Pattern.new("Cmaj").first
      chord.notes.map(&:value).should be == [36, 40, 43]

      chord = Stretto::Pattern.new("Cmaj^").first
      chord.notes.map(&:value).should be == [40, 43, 48]

      chord = Stretto::Pattern.new("Cmaj^^").first
      chord.notes.map(&:value).should be == [43, 48, 52]
    end

    it "should adjust the notes according to the chord invertion when using pivot note" do
      chord = Stretto::Pattern.new("Cmaj^E").first
      chord.pivot_note.value.should   be == 40
      chord.notes.map(&:value).should be == [40, 43, 48]

      chord = Stretto::Pattern.new("Cmaj^Fb").first
      chord.pivot_note.value.should   be == 40
      chord.notes.map(&:value).should be == [40, 43, 48]

      chord = Stretto::Pattern.new("Cmaj^D##").first
      chord.pivot_note.value.should   be == 40
      chord.notes.map(&:value).should be == [40, 43, 48]
    end

    it "should not allow to do a chord inversion if the note is not present" do
      lambda{ Stretto::Pattern.new("Cmaj^F") }.should raise_error(Stretto::Exceptions::ChordInversionsException)
    end

    it "should not allow chord inversions when the value of the inverted note goes beyond allowed value" do
      lambda { Stretto::Pattern.new("C10maj") }.should_not raise_error # C E G, last value is 127
      lambda { Stretto::Pattern.new("C10maj^") }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
    end

    it "should retain the name of the chord if available" do
      chord = Stretto::Pattern.new("Cmaj").first
      chord.named_chord.should be == 'maj'

      chord = Stretto::Pattern.new("Cmaj^^").first
      chord.named_chord.should be == 'maj'

      chord = Stretto::Pattern.new("Cmaj7<5").first
      chord.named_chord.should be == 'maj7<5'
    end

    it "should retain the base note even in an inverted chord" do
      chord = Stretto::Pattern.new("Cmaj^^").first
      chord.base_note.key.should be == 'C'
      chord.base_note.value.should be == 36
    end

  end

  context "when specifying duration" do
    it "should set the same duration for all notes of the chord" do
      chord = Stretto::Pattern.new("Cmajw").first
      chord.original_duration.should be == 'w'
      chord.duration.should be == 1.0

      chord.notes.map(&:original_duration).should be == ['w', 'w', 'w']
      chord.notes.map(&:duration).should be == [1.0, 1.0, 1.0]
    end
  end

end