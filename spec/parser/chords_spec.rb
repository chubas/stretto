require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing chords" do

  context "accepting the predefined chords" do
    CHORDS = %w{
              maj     min     aug     dim     dom7    maj7    min7    sus4    sus2
              maj6    min6    dom9    maj9    min9    dim7    add9    min11   dom11
              dom13   min13   maj13   dom7<5  dom7>5  maj7<5  maj7>5  minmaj7
              dom7<5<9        dom7<5>9        dom7>5<9        dom7>5>9
            }

    it "should parse predefined chords" do
      CHORDS.each do |chord|
        Stretto::Parser.new("C" + chord).should be_valid
      end
    end
  end

  context "specifying chord inversions" do

    context "chord inversions by position" do
      it "should not accept inversions on non-chord notes" do
        Stretto::Parser.new("C^").should_not be_valid
        Stretto::Parser.new("C^^").should_not be_valid
      end

      it "should accept chord inversions by base note position" do
        Stretto::Parser.new("Cmaj^").should be_valid
        Stretto::Parser.new("Cmaj^^").should be_valid
      end

      it "should accept chord inversions with more than the current number of notes in the lexical analysis phase" do
        Stretto::Parser.new("Cmaj^^^^^").should be_valid
      end

      it "should not allow both position and base note inversions at the same time" do
        Stretto::Parser.new("Cmaj^^E").should_not be_valid
      end
    end

    context "chord inversions by specifying base note" do
      it "should not accept inversions on non-chord notes" do
        Stretto::Parser.new("C^C").should_not be_valid
      end

      it "should accept chord inversions by specifying base note" do
        Stretto::Parser.new("Cmaj^C").should be_valid
      end

      it "should accept chord inversions even if the note is not present in the chord in lexical analysis phase" do
        Stretto::Parser.new("Cmaj^Db").should be_valid
      end
    end

  end

end
