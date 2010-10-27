require File.dirname(__FILE__) + '/../spec_helper'

describe "attack and decay velocities" do

  it "should return correctly the value of attack velocity on notes" do
    Stretto::Pattern.new("Cqa60").first.attack.should be == 60
  end

  it "should return correctly the value of attack velocity on chords" do
    Stretto::Pattern.new("Cmaja60").first.attack.should be == 60
  end

  it "should return correctly the value of decay velocity on notes" do
    Stretto::Pattern.new("Cqd40").first.decay.should be == 40
  end

  it "should return correctly the value of decay velocity on chords" do
    Stretto::Pattern.new("Cmajd40").first.decay.should be == 40
  end

  it "should return the attack and decay velocity on notes when both are present" do
    note = Stretto::Pattern.new("Ca60d40").first
    note.attack.should  be == 60
    note.decay.should   be == 40
  end
  
  it "should return the attack and decay velocity on chords when both are present" do
    chord = Stretto::Pattern.new("Cmaja60d40").first
    chord.attack.should be == 60
    chord.decay.should  be == 40
  end

  it "should not allow attack or decay values out of range" do
    lambda{ Stretto::Pattern.new("Ca127") }.should_not raise_error
    lambda{ Stretto::Pattern.new("Ca128") }.should raise_error(Stretto::Exceptions::InvalidValueException, /attack/i)

    lambda{ Stretto::Pattern.new("Cd127") }.should_not raise_error
    lambda{ Stretto::Pattern.new("Cd128") }.should raise_error(Stretto::Exceptions::InvalidValueException, /decay/i)
  end

  it "should return correct attack and decay for all notes of a chord" do
    chord = Stretto::Pattern.new("Cmaja60d40").first
    chord.notes.map(&:attack).should be == [60, 60, 60]
    chord.notes.map(&:decay).should  be == [40, 40, 40]
  end

  it "should return the default attack of 64" do
    note, chord = Stretto::Pattern.new("C Cmaj")
    note.attack.should == 64
    chord.attack.should == 64
  end

  it "should return the default decay of 64" do
    note, chord = Stretto::Pattern.new("C Cmaj")
    note.decay.should == 64
    chord.decay.should == 64
  end

  it "should return attack velocity expressed as variable" do
    Stretto::Pattern.new("$MY_VAR=60 Ca[MY_VAR]d40")[1].attack.should be == 60
  end

  it "should return decay velocity expressed as variable" do
    Stretto::Pattern.new("$MY_VAR=40 Ca60d[MY_VAR]")[1].decay.should be == 40
  end

  it "should return attack and decay velocities expressed as variables" do
    note = Stretto::Pattern.new("$MY_ATTACK=60 $MY_DECAY=40 Cmaja[MY_ATTACK]d[MY_DECAY]")[2]
    note.attack.should be == 60
    note.decay.should be == 40
  end

end
