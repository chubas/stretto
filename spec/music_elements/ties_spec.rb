require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building notes with ties" do

  it "should treat notes as separate elements even when tied" do
    Stretto::Parser.new("Cw- C-w").to_stretto.should have(2).notes
    Stretto::Parser.new("Cmajw- Cmaj-h- Cmaj-h").to_stretto.should have(3).notes
  end

  it "should return correct value of start_tie?" do
    Stretto::Parser.new("Cw- C-w").to_stretto[0].start_of_tie?.should == true
    Stretto::Parser.new("Cw- C-w").to_stretto[1].start_of_tie?.should == false
    Stretto::Parser.new("Cw Cw").to_stretto[0].start_of_tie?.should == false
  end

  it "should return correct value of end_tie?" do
    Stretto::Parser.new("Cw- C-w").to_stretto[1].end_of_tie?.should == true
    Stretto::Parser.new("Cw- C-w").to_stretto[0].end_of_tie?.should == false
    Stretto::Parser.new("Cw Cw").to_stretto[0].end_of_tie?.should == false
  end

  # Note: This is allowed in the original JFugue
  # The current JFugue behavior is to treat unfinished ties as if they didn't have it
  it "should allow ties with loose ends" do
    lambda{ Stretto::Parser.new("Cw- Cw").to_stretto }.should_not raise_error
    lambda{ Stretto::Parser.new("Cw C-w").to_stretto }.should_not raise_error
  end

  # Note: This is allowed in the original JFugue
  # Current behavior is ignore the second (and more) notes, and tie them as if it was the same
  # pitch of the first note
  it "should accept tied notes of different pitch" do
    lambda{ Stretto::Parser.new("Cw- D-w").to_stretto }.should_not raise_error
  end

  it "should not accept tied chord when the chords are different" do
    lambda{ Stretto::Parser.new("Cmajw- Cmin-w").to_stretto }.should_not raise_error
  end

  it "should accept valid ties with notes, chords and rests" do
    lambda{ Stretto::Parser.new("Cw- C-w- C-w").to_stretto }.should_not raise_error
    lambda{ Stretto::Parser.new("Cmajw- Cmaj-w- Cmaj-w").to_stretto }.should_not raise_error
    lambda{ Stretto::Parser.new("Rw- R-w- R-w").to_stretto }.should_not raise_error
  end

end