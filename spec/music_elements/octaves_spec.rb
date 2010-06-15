require File.join(File.dirname(__FILE__), '../spec_helper')

context "parsing octaves" do

  context "parsing octaves on notes" do
    it "should parse the specified octave on a note" do
      chord = Stretto::Parser.new("C7").to_stretto.first
      chord.original_octave.should be == '7'
      chord.octave.should          be == 7
    end

    it "should calculate correctly the octave for a note given its value" do
      chord = Stretto::Parser.new("[0]").to_stretto.first
      chord.original_octave.should be == nil
      chord.octave.should          be == 0

      Stretto::Parser.new("[11]").to_stretto.first.octave.should be == 0
      Stretto::Parser.new("[60]").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("[65]").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("[70]").to_stretto.first.octave.should be == 5
      Stretto::Parser.new("[120]").to_stretto.first.octave.should be == 10
      Stretto::Parser.new("[127]").to_stretto.first.octave.should be == 10
    end

    it "should correctly set a default octave of 5 when it is not specified" do
      chord = Stretto::Parser.new("C").to_stretto.first
      chord.original_octave.should be == nil
      chord.octave.should          be == 5

      Stretto::Parser.new("A").to_stretto.first.octave.should be == 5
    end
  end

  context "parsing octaves on chords" do
    it "should parse the specified octave on a chord"
    it "should calculate correctly the octave for the base note on a chord given its value"
    it "should correctly set a default octave of 3 for chords when it is not specified"
  end

end