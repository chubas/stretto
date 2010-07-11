require File.dirname(__FILE__) + '/../spec_helper'

context "parsing octaves" do

  context "parsing octaves on notes" do
    it "should parse the specified octave on a note" do
      note = Stretto::Pattern.new("C7").first
      note.original_octave.should be == '7'
      note.octave.should          be == 7
    end

    it "should calculate correctly the octave for a note given its value" do
      note = Stretto::Pattern.new("[0]").first
      note.original_octave.should be == nil
      note.octave.should          be == 0

      Stretto::Pattern.new("[11]").first.octave.should be == 0
      Stretto::Pattern.new("[60]").first.octave.should be == 5
      Stretto::Pattern.new("[65]").first.octave.should be == 5
      Stretto::Pattern.new("[70]").first.octave.should be == 5
      Stretto::Pattern.new("[120]").first.octave.should be == 10
      Stretto::Pattern.new("[127]").first.octave.should be == 10
    end

    it "should correctly set a default octave of 5 when it is not specified" do
      note = Stretto::Pattern.new("C").first
      note.original_octave.should be == nil
      note.octave.should          be == 5

      Stretto::Pattern.new("A").first.octave.should be == 5
      Stretto::Pattern.new("G").first.octave.should be == 5
    end
  end

  context "parsing octaves on chords" do
    
    it "should parse the specified octave on the base note of a chord" do
      Stretto::Pattern.new("C1maj").first.octave.should  be == 1
      Stretto::Pattern.new("C3maj").first.octave.should  be == 3
      Stretto::Pattern.new("C5maj").first.octave.should  be == 5
      Stretto::Pattern.new("C10maj").first.octave.should be == 10
    end
    
    it "should calculate correctly the octave for the base note on a chord given its value" do
      Stretto::Pattern.new("[0]maj").first.octave.should   be == 0
      Stretto::Pattern.new("[11]maj").first.octave.should  be == 0
      Stretto::Pattern.new("[60]maj").first.octave.should  be == 5
      Stretto::Pattern.new("[120]maj").first.octave.should be == 10
    end

    it "should correctly set a default octave of 3 for chords when it is not specified" do
      Stretto::Pattern.new("Amaj").first.octave.should be == 3
      Stretto::Pattern.new("Cmaj").first.octave.should be == 3
      Stretto::Pattern.new("Gmaj").first.octave.should be == 3
    end

  end

end