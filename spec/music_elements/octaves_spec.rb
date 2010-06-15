require File.join(File.dirname(__FILE__), '../spec_helper')

context "parsing octaves" do

  context "parsing octaves on notes" do
    it "should parse the specified octave on a note" do
      note = Stretto::Parser.new("C7").to_stretto.first
      note.original_octave.should be == '7'
      note.octave.should          be == 7
    end

    it "should calculate correctly the octave for a note given its value" do
      note = Stretto::Parser.new("[0]").to_stretto.first
      note.original_octave.should be == nil
      note.octave.should          be == 0

      Stretto::Parser.new("[11]").to_stretto.first.octave.should be == 0
      Stretto::Parser.new("[60]").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("[65]").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("[70]").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("[120]").to_stretto.first.octave.should be == 10
      Stretto::Parser.new("[127]").to_stretto.first.octave.should be == 10
    end

    it "should correctly set a default octave of 5 when it is not specified" do
      note = Stretto::Parser.new("C").to_stretto.first
      note.original_octave.should be == nil
      note.octave.should          be == 5

      Stretto::Parser.new("A").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("G").to_stretto.first.octave.should be == 5
    end
  end

  context "parsing octaves on chords" do
    
    it "should parse the specified octave on the base note of a chord" do
      Stretto::Parser.new("C1maj").to_stretto.first.octave.should  be == 1
      Stretto::Parser.new("C3maj").to_stretto.first.octave.should  be == 3
      Stretto::Parser.new("C5maj").to_stretto.first.octave.should  be == 5
      Stretto::Parser.new("C10maj").to_stretto.first.octave.should be == 10
    end
    
    it "should calculate correctly the octave for the base note on a chord given its value" do
      Stretto::Parser.new("[0]maj").to_stretto.first.octave.should   be == 0
      Stretto::Parser.new("[11]maj").to_stretto.first.octave.should  be == 0
      Stretto::Parser.new("[60]maj").to_stretto.first.octave.should  be == 5
      Stretto::Parser.new("[120]maj").to_stretto.first.octave.should be == 10
    end

    it "should correctly set a default octave of 3 for chords when it is not specified" do
      Stretto::Parser.new("Amaj").to_stretto.first.octave.should be == 3
      Stretto::Parser.new("Cmaj").to_stretto.first.octave.should be == 3
      Stretto::Parser.new("Gmaj").to_stretto.first.octave.should be == 3
    end

  end

end