require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Note do

  context "when creating it from its string representation" do
    it "should return its pitch correctly" do
      Stretto::MusicElements::Note.new("C").pitch.should be == 60
    end

    it "should return its duration correctly" do
      Stretto::MusicElements::Note.new("Cw").duration.should be == 1.0
    end

    it "should return its octave correctly" do
      Stretto::MusicElements::Note.new("C3").octave.should be == 3
    end

    it "should return its key correctly" do
      Stretto::MusicElements::Note.new("C#").key.should be == "C"
    end

    it "should return its accidental correctly" do
      Stretto::MusicElements::Note.new("C##").accidental.should be == "##"
    end

    ALL_ELEMENTS.except(:note).each do |element, string|
      it "should not parse #{element} as note" do
        lambda do
          Stretto::MusicElements::Note.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /note/i)
      end
    end
  end

  context "when using variable notation to indicate its pitch" do
    it "should accept predefined variables" do
      note = Stretto::MusicElements::Note.new("[ALLEGRO]w")
      note.pitch.should be == 120
      note.pattern.should be_nil
    end

    it "should not accept undefined variables" do
      note = Stretto::MusicElements::Note.new("[SOME_VAR]w")
      lambda do
        note.pitch
      end.should raise_error(Stretto::Exceptions::VariableContextException, /pattern/)
    end

    it "should accept variables when attached to a pattern" do
      pattern = Stretto::Pattern.new("$SOME_VAR=60")
      note = Stretto::MusicElements::Note.new("[SOME_VAR]w")
      pattern << note
      note.pitch.should be == 60
      note.duration.should be == 1.0
    end
  end

end