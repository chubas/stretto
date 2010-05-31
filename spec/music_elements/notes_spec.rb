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

      note.original_key.should be == 'C'
      
      note.value.should be == 60

      note.original_duration.should be == 'h'
      note.duration.should be == 0.5

      note.original_octave.should be == '5'
      note.octave.should be == 5
    end
  end

end