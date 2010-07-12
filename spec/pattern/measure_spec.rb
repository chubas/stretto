require File.dirname(__FILE__) + '/../spec_helper'

describe "measures" do

  it "should parse the correct number of elements" do
    Stretto::Pattern.new("A | Bmin | R").should have(5).elements
  end

  it "should return the correct type of element when parsing measures" do
    pattern = Stretto::Pattern.new("A | Bmin | R")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::Note)
    pattern[1].should be_an_instance_of(Stretto::MusicElements::Measure)
    pattern[2].should be_an_instance_of(Stretto::MusicElements::Chord)
    pattern[3].should be_an_instance_of(Stretto::MusicElements::Measure)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::Rest)
  end

  it "should allow measures at the beginning of a pattern" do
    Stretto::Pattern.new("| C D")[0].should be_an_instance_of(Stretto::MusicElements::Measure)
  end

  it "should allow measures in middle of a pattern" do
    Stretto::Pattern.new("C | D")[1].should be_an_instance_of(Stretto::MusicElements::Measure)
  end

  it "should allow measures at the end of a pattern" do
    Stretto::Pattern.new("C D |")[2].should be_an_instance_of(Stretto::MusicElements::Measure)
  end

  it "should allow arbitrarily as many measures next to each other" do
    Stretto::Pattern.new("| | | | |").should have(5).elements
  end

  context "accessing its properties" do
    it "should have a duration of 0" do
      measure = Stretto::Pattern.new("|").first
      measure.should respond_to(:duration)
      measure.duration.should be == 0
    end

    it "should return a simple bar when accessing its original string" do
      Stretto::Pattern.new("|").first.original_string.should be == '|'
    end
  end

  context "when appearing in the middle of tied notes" do
    it "should not break tied notes" do
      pattern = Stretto::Pattern.new("Cw- | C-w- | C-w")
      pattern.should have(5).elements
      
      first_note = pattern[0]
      first_note.tied_elements.map(&:original_string).should be == ['Cw-', 'C-w-', 'C-w']
      first_note.tied_duration.should be == 3.0

      second_note = pattern[2]
      second_note.tied_duration.should be == 2.0
      second_note.tied_elements.map(&:original_string).should be == ['C-w-', 'C-w']

      third_note = pattern[4]
      third_note.tied_duration.should be == 1.0
      third_note.tied_elements.map(&:original_string).should be == ['C-w']
    end

    it "should not break tied chords" do
      pattern = Stretto::Pattern.new("Cmaj7w- | Cmaj7-w")
      pattern.first.tied_duration.should be == 2.0
      pattern.first.should have(2).tied_elements
    end

    it "should not break tied rests" do
      pattern = Stretto::Pattern.new("Rw- | R-w")
      pattern.first.tied_duration.should be == 2.0
      pattern.first.should have(2).tied_elements
    end

    it "should return the number of tied notes as if it was called from the note after" do
      measure = Stretto::Pattern.new("Cw- | C-w- | C-w")[1]
      measure.should have(2).tied_elements
      measure.duration.should be == 0
      measure.tied_duration.should be == 2.0
    end

    it "should not alter note if there is not tied element" do
      measure = Stretto::Pattern.new("| Rw").first
      measure.should have(1).tied_elements
      measure.duration.should be == 0
      measure.tied_duration.should be == 1.0
    end
  end

end