require File.join(File.dirname(__FILE__), '../spec_helper')

describe "building notes" do

  context "parsing notes or sequences of notes" do
    it "should return the correct number and kind of notes with one note" do
      notes = Stretto::Pattern.new("C")
      notes.should have(1).note
      notes[0].should be_an_instance_of Stretto::MusicElements::Note
    end

    it "should return the correct number and kind of notes with several notes" do
      notes = Stretto::Pattern.new("C D E F")
      notes.should have(4).notes
      notes.each { |note| note.should be_an_instance_of Stretto::MusicElements::Note }
    end
  end

  context "parsing notes with note syntax" do
    it "should correctly parse note values" do
      note = Stretto::Pattern.new("C5h").first
      note.original_string.should be == 'C5h'
      note.original_key.should    be == 'C'
      note.key.should             be == 'C'
      note.original_value.should  be_nil
      note.value.should           be == 60
    end
  end

  context "parsing notes with numeric value syntax" do
    it "should correctly parse note values" do
      note = Stretto::Pattern.new("[60]w").first
      note.original_string.should be == '[60]w'
      note.original_key.should    be_nil
      note.key.should             be == 'C'
      note.original_value.should  be == '60'
      note.value.should           be == 60
    end

    it "should should not allow values above 127" do
      lambda{ Stretto::Pattern.new("[127]") }.should_not raise_error
      lambda{ Stretto::Pattern.new("[128]") }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
    end

    it "should not allow notes past the value 127 with note syntax" do
      lambda{ Stretto::Pattern.new("G10")   }.should_not raise_error
      lambda{ Stretto::Pattern.new("G#10")  }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
      lambda{ Stretto::Pattern.new("Ab10")  }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
      lambda{ Stretto::Pattern.new("Abb10") }.should_not raise_error
    end

    it "should not be affected by a key signature" do
      note = Stretto::Pattern.new("KGmaj [65]")[1]
      note.value.should be == 65 # The equivalent to a F, being F# because of the key Gmaj
    end
  end

  context "parsing notes with variable value syntax" do
    it "should correctly parse note values" do
      Stretto::Pattern.new("$MY_VAR=100 [MY_VAR]")[1].should be_an_instance_of(Stretto::MusicElements::Note)
    end

    it "should return correctly its value and original value" do
      note = Stretto::Pattern.new("$MY_VAR=100 [MY_VAR]")[1]
      note.value.should be == 100
      note.original_value.should be == "[MY_VAR]"
    end

    it "should throw an error when value is over 127" do
      lambda{ Stretto::Pattern.new("$MY_VAR=127 [MY_VAR]") }.should_not raise_error
      lambda{ Stretto::Pattern.new("$MY_VAR=128 [MY_VAR]") }.should raise_error(Stretto::Exceptions::NoteOutOfBoundsException)
    end

    it "should not store original key, octave nor accidental" do
      note = Stretto::Pattern.new("$MY_VAR=61 [MY_VAR]")[1]
      note.value.should be == 61 # The equivalent to a C#5
      note.original_value.should be == "[MY_VAR]"

      note.key.should be == "C"
      note.original_key.should be_nil

      note.accidental.should be == "#"
      note.original_accidental.should be_nil

      note.octave.should be == 5
      note.original_octave.should be_nil
    end

    it "should not be affected by a key signature" do
      note = Stretto::Pattern.new("KGmaj $MY_VAR=65 [MY_VAR]")[2]
      note.value.should be == 65 # The equivalent to a F, being F# because of the key Gmaj
    end
  end

end