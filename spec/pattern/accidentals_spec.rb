require File.dirname(__FILE__) + '/../spec_helper'

describe "attaching accidentals to notes and chords" do

  context "when attaching accidentals to notes" do

    it "should diminish by two tones when using bb accidental" do
      note = Stretto::Pattern.new("Cbb").first
      note.original_accidental.should be == "bb"
      note.accidental.should be == 'bb'
      note.pitch.should be == 58
    end

    it "should diminish by one tone when using b accidental" do
      note = Stretto::Pattern.new("Cb").first
      note.original_accidental.should be == "b"
      note.accidental.should be == 'b'
      note.pitch.should be == 59
    end

    it "should not affect notes when using the natural accidental" do
      note = Stretto::Pattern.new("Cn").first
      note.original_accidental.should be == "n"
      note.accidental.should be == 'n'
      note.pitch.should be == 60
    end

    it "should augment by one tone when using # accidental" do
      note = Stretto::Pattern.new("C#").first
      note.original_accidental.should be == "#"
      note.accidental.should be == '#'
      note.pitch.should be == 61
    end

    it "should augment by two tone when using ## accidental" do
      note = Stretto::Pattern.new("C##").first
      note.original_accidental.should be == "##"
      note.accidental.should be == '##'
      note.pitch.should be == 62
    end

  end

  context "when attaching accidentals to chords" do

    it "should diminish by two tones when using the bb accidental" do
      chord = Stretto::Pattern.new("Cbbmaj").first
      chord.original_accidental.should be == "bb"
      chord.accidental.should be == 'bb'
      chord.base_note.pitch.should be == 34
    end

    it "should diminish by one tone when using the b accidental" do
      chord = Stretto::Pattern.new("Cbmaj").first
      chord.original_accidental.should be == "b"
      chord.accidental.should be == 'b'
      chord.base_note.pitch.should be == 35
    end

    it "should not modify the note when using the natural accidental" do
      chord = Stretto::Pattern.new("Cnmaj").first
      chord.original_accidental.should be == "n"
      chord.accidental.should be == 'n'
      chord.base_note.pitch.should be == 36
    end

    it "should augment by one tone when using the # accidental" do
      chord = Stretto::Pattern.new("C#maj").first
      chord.original_accidental.should be == "#"
      chord.accidental.should be == '#'
      chord.base_note.pitch.should be == 37
    end

    it "should augment by two tones when using the ## accidental" do
      chord = Stretto::Pattern.new("C##maj").first
      chord.original_accidental.should be == "##"
      chord.accidental.should be == '##'
      chord.base_note.pitch.should be == 38
    end

  end

  context "applying accidental to the base note of a chord" do
    it "should push notes according to the accidental modifier" do
      Stretto::Pattern.new("Cbbmaj").first.notes.map(&:pitch).should be == [34, 38, 41]
      Stretto::Pattern.new("Cbmaj").first.notes.map(&:pitch).should  be == [35, 39, 42]
      Stretto::Pattern.new("Cnmaj").first.notes.map(&:pitch).should  be == [36, 40, 43]
      Stretto::Pattern.new("C#maj").first.notes.map(&:pitch).should  be == [37, 41, 44]
      Stretto::Pattern.new("C##maj").first.notes.map(&:pitch).should be == [38, 42, 45]
    end

    it "should retain the accidental in chord invertions" do
      chord = Stretto::Pattern.new("Cbbmaj^").first
      chord.notes.map(&:pitch).should be == [38, 41, 46]
      chord.base_note.original_accidental.should be == 'bb'
      chord.base_note.accidental.should be == 'bb' 
    end
  end

end