require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::HarmonicChord do

  context "when creating it from its string representation" do
    it "should return its notes correctly" do
      Stretto::MusicElements::HarmonicChord.new("C+D+E").should have(3).notes
    end

    it "should store the notes in the correct order" do
      # In harmonic chords, the default octave is not 3 as in chords, but 5, for the individual notes
      Stretto::MusicElements::HarmonicChord.new("C+D+E").notes.map(&:pitch).should be == [60, 62, 64]
    end

    it "should return its duration correctly" do
      Stretto::MusicElements::HarmonicChord.new("C+D+Ew").duration.should be == 1.0
    end

    ALL_ELEMENTS.except(:harmonic_chord).each do |element, string|
      it "should not parse #{element} as a harmonic chord" do
        lambda do
          Stretto::MusicElements::HarmonicChord.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /harmonic chord/i)
      end
    end
  end

end