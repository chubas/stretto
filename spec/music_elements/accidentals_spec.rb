require File.join(File.dirname(__FILE__), '../spec_helper')

describe "attaching accidentals to notes and chords" do

  context "when attaching accidentals to notes" do

    it "should diminish by two tones when using bb accidental" do
      note = Stretto::Parser.new("Cbb").to_stretto.first
      note.original_accidental.should be == "bb"
      note.accidental.should be == 'bb'
      note.value.should be == 58
    end

    it "should diminish by one tone when using b accidental" do
      note = Stretto::Parser.new("Cb").to_stretto.first
      note.original_accidental.should be == "b"
      note.accidental.should be == 'b'
      note.value.should be == 59
    end

    it "should not affect notes when using the natural accidental" do
      note = Stretto::Parser.new("Cn").to_stretto.first
      note.original_accidental.should be == "n"
      note.accidental.should be == 'n'
      note.value.should be == 60
    end

    it "should augment by one tone when using # accidental" do
      note = Stretto::Parser.new("C#").to_stretto.first
      note.original_accidental.should be == "#"
      note.accidental.should be == '#'
      note.value.should be == 61
    end

    it "should augment by two tone when using ## accidental" do
      note = Stretto::Parser.new("C##").to_stretto.first
      note.original_accidental.should be == "##"
      note.accidental.should be == '##'
      note.value.should be == 62
    end

  end

  context "when attaching accidentals to chords" do

    it "should diminish by two tones when using the bb accidental" do
      chord = Stretto::Parser.new("Cbbmaj").to_stretto.first
      chord.original_accidental.should be == "bb"
      chord.accidental.should be == 'bb'
      chord.base_note.value.should be == 34
    end

    it "should diminish by one tone when using the b accidental" do
      chord = Stretto::Parser.new("Cbmaj").to_stretto.first
      chord.original_accidental.should be == "b"
      chord.accidental.should be == 'b'
      chord.base_note.value.should be == 35
    end

    it "should not modify the note when using the natural accidental" do
      chord = Stretto::Parser.new("Cnmaj").to_stretto.first
      chord.original_accidental.should be == "n"
      chord.accidental.should be == 'n'
      chord.base_note.value.should be == 36
    end

    it "should augment by one tone when using the # accidental" do
      chord = Stretto::Parser.new("C#maj").to_stretto.first
      chord.original_accidental.should be == "#"
      chord.accidental.should be == '#'
      chord.base_note.value.should be == 37
    end

    it "should augment by two tones when using the ## accidental" do
      chord = Stretto::Parser.new("C##maj").to_stretto.first
      chord.original_accidental.should be == "##"
      chord.accidental.should be == '##'
      chord.base_note.value.should be == 38
    end

  end

  context "applying accidental to the base note of a chord" do
    it "should push notes according to the accidental modifier" do
      Stretto::Parser.new("Cbbmaj").to_stretto.first.notes.map(&:value).should be == [34, 38, 41]
      Stretto::Parser.new("Cbmaj").to_stretto.first.notes.map(&:value).should  be == [35, 39, 42]
      Stretto::Parser.new("Cnmaj").to_stretto.first.notes.map(&:value).should  be == [36, 40, 43]
      Stretto::Parser.new("C#maj").to_stretto.first.notes.map(&:value).should  be == [37, 41, 44]
      Stretto::Parser.new("C##maj").to_stretto.first.notes.map(&:value).should be == [38, 42, 45]
    end

    it "should retain the accidental in chord invertions" do
      chord = Stretto::Parser.new("Cbbmaj^").to_stretto.first
      chord.notes.map(&:value).should be == [38, 41, 46]
      chord.base_note.original_accidental.should be == 'bb'
      chord.base_note.accidental.should be == 'bb' 
    end
  end

end