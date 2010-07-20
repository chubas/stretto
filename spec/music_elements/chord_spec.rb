require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Chord do

  context "when creating it from its string representation" do
    it "should return its notes correctly" do
      Stretto::MusicElements::Chord.new("Cmaj").should have(3).notes
    end

    it "should build the correct notes individually" do
      Stretto::MusicElements::Chord.new("C#5maj").notes.map(&:pitch).should be == [61, 65, 68]
    end

    it "should return its base note" do
      Stretto::MusicElements::Chord.new("Cmaj").base_note.should be == Stretto::MusicElements::Note.new("C3")
    end

    it "should return its named chord correctly" do
      Stretto::MusicElements::Chord.new("Cmaj").named_chord.should be == 'maj'
    end

    it "should return its number of inversions" do
      Stretto::MusicElements::Chord.new("Cmaj^^").inversions.should be == 2
    end

    it "should return its pivot note correctly" do
      Stretto::MusicElements::Chord.new("Cmaj^E").pivot_note.should be == Stretto::MusicElements::Note.new("E3")
    end

    it "should return its duration correctly" do
      Stretto::MusicElements::Chord.new("Cmajh").duration.should be == 0.5
    end

    ALL_ELEMENTS.except(:chord).each do |element, string|
      it "should not parse #{element} as a chord" do
        lambda do
          Stretto::MusicElements::Chord.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /chord/i)
      end
    end
  end

  context "when using variable notation to indicate the pitch of the base note" do
    it "should accept predefined variables" do
      chord = Stretto::MusicElements::Chord.new("[PIANO]maj")
      chord.base_note.should be == Stretto::MusicElements::Note.new("C0")
    end

    it "should not accept undefined variables" do
      chord = Stretto::MusicElements::Chord.new("[SOME_VAR]maj")
      accessors = [lambda{ chord.base_note.pitch}, lambda{ chord.notes}]
      accessors.each { |proc| proc.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i) }
    end

    it "should accept variables when attached to a pattern" do
      pattern = Stretto::Pattern.new("$SOME_VAR=80")
      chord = Stretto::MusicElements::Chord.new("[SOME_VAR]maj")
      pattern << chord
      chord.notes.map(&:pitch).should be == [80, 84, 87]
    end
  end

end