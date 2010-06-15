require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building notes" do

  context "parsing notes or sequences of notes" do
    it "should return the correct number and kind of notes with one note" do
      notes = Stretto::Parser.new("C").to_stretto
      notes.should have(1).note
      notes[0].should be_an_instance_of Stretto::MusicElements::Note
    end

    it "should return the correct number and kind of notes with several notes" do
      notes = Stretto::Parser.new("C D E F").to_stretto
      notes.should have(4).notes
      notes.each{|note| note.should be_an_instance_of Stretto::MusicElements::Note }
    end
  end

  context "parsing notes with note syntax" do
    it "should correctly parse note values" do
      note = Stretto::Parser.new("C5h").to_stretto.first
      note.original_string.should be == 'C5h'
      note.original_key.should    be == 'C'
      note.key.should             be == 'C'
      note.original_value.should  be_nil
      note.value.should           be == 60
    end
  end

  context "parsing notes with numeric value syntax" do
    it "should correctly parse note values" do
      note = Stretto::Parser.new("[60]w").to_stretto.first
      note.original_string.should be == '[60]w'
      note.original_key.should    be_nil
      note.key.should             be == 'C'
      note.original_value.should  be == '60'
      note.value.should           be == 60
    end

    it "should should not allow values above 127" do
      Stretto::Parser.new("[127]").should be_valid
      lambda{ Stretto::Parser.new("[128]").to_stretto }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
    end

    it "should not allow notes past the value 127 with note syntax" do
      Stretto::Parser.new("G10").should be_valid
      lambda{ Stretto::Parser.new("G#10").to_stretto }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
      lambda{ Stretto::Parser.new("Ab10").to_stretto }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
      Stretto::Parser.new("Abb10").should be_valid
    end
  end

  context "parsing notes with constant value syntax" do
    it "should correctly parse note values" # Add test when variables are implemented
  end

end