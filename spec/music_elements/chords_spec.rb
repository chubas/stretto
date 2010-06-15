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

end