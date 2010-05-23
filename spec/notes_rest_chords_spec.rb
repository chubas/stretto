require File.join(File.dirname(__FILE__), '../lib/stretto')

describe "Notes" do

  context "an empty composition" do
    it "should parse an empty composition" do
      parser = Stretto::Parser.new("")
      parser.to_stretto.should be == []
    end
  end

  context "specifying natural notes" do

    it "should parse a note" do
      notes = Stretto::Parser.new("C").to_stretto
      notes.should have(1).note
    end

    it "should parse a sequence of notes" do
      notes = Stretto::Parser.new("C D E").to_stretto
      notes.should have(3).notes
    end

    it "should parse notes expressed numerically" do
      notes = Stretto::Parser.new("[60]").to_stretto
      notes.should have(1).notes
    end

    it "should parse a sequence of notes expressed numerically" do
      notes = Stretto::Parser.new("[60] [61] [63]").to_stretto
      notes.should have(3).notes
    end

    it "should not allow note values below 0" do
      parser = Stretto::Parser.new("[-1]")
      lambda { parser.to_stretto }.should raise_error(InvalidValueException, /0 - 127/)
    end

    it "should not allow note values above 127" do
      parser = Stretto::Parser.new("[128]")
      lambda { parser.to_stretto }.should raise_error(InvalidValueException, /0 - 127/)
    end
  end

  context "specifying sharp, flats and natural accidentals" do

    it "should parse notes with sharp accidentals" do
      notes = Stretto::Parser.new("A#").to_stretto
      notes.should have(1).notes
    end

    it "should parse notes with flat accidentals" do
      notes = Stretto::Parser.new("Ab").to_stretto
      notes.should have(1).notes
    end

    it "should parse notes with double sharp accidentals" do
      notes = Stretto::Parser.new("A##").to_stretto
      notes.should have(1).notes
    end

    it "should parse notes with double flat accidentals" do
      notes = Stretto::Parser.new("Abb").to_stretto
      notes.should have(1).notes
    end

    it "should parse notes with naturals" do
      notes = Stretto::Parser.new("An").to_stretto
      notes.should have(1).notes
    end
    
  end

  context "specifying chords" do

    CHORDS = %w{
              maj     min     aug     dim     dom7    maj7    min7    sus4    sus2
              maj6    min6    dom9    maj9    min9    dim7    add9    min11   dom11
              dom13   min13   maj13   dom7<5  dom7>5  maj7<5  maj7>5  minmaj7
              dom7<5<9        dom7<5>9        dom7>5<9        dom7>5>9
            }

    it "should allow valid chords" do
      CHORDS.each do |chord|
        chords = Stretto::Parser.new("C" + chord).to_stretto
        chords.should have(1).chord
      end
    end

  end

end