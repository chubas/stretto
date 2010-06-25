require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building notes with ties" do

  it "should treat notes as separate elements even when tied" do
    Stretto::Pattern.new("Cw- C-w").should have(2).notes
    Stretto::Pattern.new("Cmajw- Cmaj-h- Cmaj-h").should have(3).notes
  end

  it "should return correct value of start_tie?" do
    Stretto::Pattern.new("Cw- C-w")[0].start_of_tie?.should be == true
    Stretto::Pattern.new("Cw- C-w")[1].start_of_tie?.should be == false
    Stretto::Pattern.new("Cw Cw")[0].start_of_tie?.should be == false
  end

  it "should return correct value of end_tie?" do
    Stretto::Pattern.new("Cw- C-w")[1].end_of_tie?.should be == true
    Stretto::Pattern.new("Cw- C-w")[0].end_of_tie?.should be == false
    Stretto::Pattern.new("Cw Cw")[0].end_of_tie?.should be == false
  end

  # Note: This is allowed in the original JFugue
  # The current JFugue behavior is to treat unfinished ties as if they didn't have it
  it "should allow ties with loose ends" do
    lambda{ Stretto::Pattern.new("Cw- Cw") }.should_not raise_error
    lambda{ Stretto::Pattern.new("Cw C-w") }.should_not raise_error
  end

  # Note: This is allowed in the original JFugue
  # Current behavior is ignore the second (and more) notes, and tie them as if it was the same
  # pitch of the first note
  it "should accept tied notes of different pitch" do
    lambda{ Stretto::Pattern.new("Cw- D-w") }.should_not raise_error
  end

  it "should not accept tied chord when the chords are different" do
    lambda{ Stretto::Pattern.new("Cmajw- Cmin-w") }.should_not raise_error
  end

  it "should accept valid ties with notes, chords and rests" do
    lambda{ Stretto::Pattern.new("Cw- C-w- C-w") }.should_not raise_error
    lambda{ Stretto::Pattern.new("Cmajw- Cmaj-w- Cmaj-w") }.should_not raise_error
    lambda{ Stretto::Pattern.new("Rw- R-w- R-w") }.should_not raise_error
  end

  it "should return the set of tied notes" do
    first, second, third = Stretto::Pattern.new("Cw- C-h Cq")
    first.tied_elements.should be == [first, second]
    first.tied_duration.should be == 1.5
    first.duration.should be == 1.0
    second.duration.should be == 0.5
    third.duration.should be == 0.25

    first, second, third = Stretto::Pattern.new("Cw- C-h- C-q")
    first.tied_elements.should be == [first, second, third]
    first.tied_duration.should be == 1.75
    first.duration.should be == 1.0
    second.duration.should be == 0.5
    third.duration.should be == 0.25
  end

  it "should return the set of tied chords" do
    first, second, third = Stretto::Pattern.new("Cmajw- Cmaj-h Cmajq")
    first.tied_elements.should be == [first, second]
    first.tied_duration.should be == 1.5
    first.duration.should be == 1.0
    second.duration.should be == 0.5
    third.duration.should be == 0.25

    first, second, third = Stretto::Pattern.new("Cmajw- Cmaj-h- Cmaj-q")
    first.tied_elements.should be == [first, second, third]
    first.tied_duration.should be == 1.75
    first.duration.should be == 1.0
    second.duration.should be == 0.5
    third.duration.should be == 0.25
  end

  it "should return the set of tied rests" do
    first, second, third = Stretto::Pattern.new("Rh- R-h Rh")
    first.tied_elements.should be == [first, second]
    first.tied_duration.should be == 1.0
    first.duration.should be == 0.5
    second.duration.should be == 0.5
    third.duration.should be == 0.5
  end

  it "should accept notes of different pitch as the same set of tied notes" do
    first, second, third = Stretto::Pattern.new("Cw- D-h- E-q")
    first.tied_elements.should be == [first, second, third]
    first.tied_duration.should be == 1.75
    first.duration.should be == 1.0
    second.duration.should be == 0.5
    third.duration.should be == 0.25
  end

  it "should accept chords of different pitch as the same set of tied chords" do
    first, second, third = Stretto::Pattern.new("Cmajw- Dmin7-h- Edom13-q")
    first.tied_elements.should be == [first, second, third]
    first.tied_duration.should be == 1.75
    first.duration.should be == 1.0
    second.duration.should be == 0.5
    third.duration.should be == 0.25
  end

  it "should return an array with a single note if the note doesn't have tied notes to the right" do
    note = Stretto::Pattern.new("Cq Cq-").first
    note.tied_elements.should be == [note]
    note.tied_duration.should be == 0.25
  end

  it "should return the set of tied notes from the note it was called, and not consider past tied notes" do
    notes = Stretto::Pattern.new("Cq- C-q- C-q- C-q")
    notes[0].should have(4).tied_elements
    notes[0].tied_duration.should be == 1.0
    notes[1].should have(3).tied_elements
    notes[1].tied_duration.should be == 0.75
    notes[2].should have(2).tied_elements
    notes[2].tied_duration.should be == 0.5
    notes[3].should have(1).tied_elements
    notes[3].tied_duration.should be == 0.25
  end

  it "should cut out the tied set of elements when they are of different type" do
    elements = Stretto::Pattern.new("C-q- C-q- Emaj-q- Emin7-q- R-q- R-q-")
    elements[0].should have(2).tied_elements
    elements[0].tied_duration.should be == 0.5
    elements[1].should have(1).tied_elements
    elements[1].tied_duration.should be == 0.25
    elements[2].should have(2).tied_elements
    elements[2].tied_duration.should be == 0.5
    elements[3].should have(1).tied_elements
    elements[3].tied_duration.should be == 0.25
    elements[4].should have(2).tied_elements
    elements[4].tied_duration.should be == 0.5
    elements[5].should have(1).tied_elements
    elements[5].tied_duration.should be == 0.25
  end

  it "should return the set of tied notes when there is a vertical bar in between" do
    elements = Stretto::Pattern.new("Cq- | C-h- | C-q")
    elements[0].should have(3).tied_elements
    elements[2].should have(2).tied_elements
    elements[4].should have(1).tied_elements
  end
  
end