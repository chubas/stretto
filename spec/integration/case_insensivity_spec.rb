require File.dirname(__FILE__) + '/../spec_helper'

describe "notes when mixing case" do

  it "should allow case insensitive note pitches" do
    notes = Stretto::Pattern.new("c5 d5 e5 f5 g5 a5 b5")
    notes.each{ |note| note.should be_an_instance_of(Stretto::MusicElements::Note) }
    notes.map(&:pitch).should be == [60, 62, 64, 65, 67, 69, 71]
    notes.map(&:key).should be == %w{C D E F G A B}
    notes.map(&:original_key).should be == %w{c d e f g a b}
  end

  it "should allow case insensitive duration values" do
    notes = Stretto::Pattern.new("CW CH CQ CI CS CT CX CO")
    notes.map(&:duration).should be == [1.0, 0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625, 0.0078125]
    notes.map(&:original_duration).should be == %w{W H Q I S T X O}
  end

  it "should allow case insensitive rests" do
    rest = Stretto::Pattern.new("r").first
    rest.should be_an_instance_of(Stretto::MusicElements::Rest)
  end

  it "should allow case insensitive accidentals" do
    notes = Stretto::Pattern.new("CBB CB CN")
    notes.map(&:pitch).should be == [58, 59, 60]
    notes.map(&:accidental).should be == %w{bb b n}
    notes.map(&:original_accidental).should be == %w{BB B N}
  end

  it "should allow case insensitive chords" do
    pattern = <<-CHORDS
      CMAJ CMIN CAUG CDIM CDOM7 CMAJ7 CMIN7 CSUS4 CSUS2 CMAJ6 CMIN6
      CDOM9 CMAJ9 CMIN9 CDIM7 CADD9 CMIN11 CDOM11 CDOM13 CMIN13 CMAJ13
      CDOM7<5 CDOM7>5 CMAJ7<5 CMAJ7>5 CMINMAJ7
      CDOM7<5<9 CDOM7<5>9 CDOM7>5<9 CDOM7>5>9
    CHORDS
    Stretto::Pattern.new(pattern).should be == Stretto::Pattern.new(pattern.downcase)
  end

  it "should allow mixed case chords" do
    chords = Stretto::Pattern.new("CMAJ CmaJ CMaJ CmAj Cmaj")
    chords.each{ |chord| chord.should be_an_instance_of(Stretto::MusicElements::Chord) }
    chords.map(&:notes).uniq.flatten.map(&:pitch).should be == [36, 40, 43]
    chords.map(&:named_chord).should be == %w{maj maj maj maj maj}
    chords.map(&:original_named_chord).should be == %w{MAJ maJ MaJ mAj maj}
  end

  it "should allow case insensitive chord invertions" do
    chord = Stretto::Pattern.new("Cmaj^e").first
    chord.pivot_note.pitch.should be == 40
    chord.notes.map(&:pitch).should be == [40, 43, 48]
  end

  it "should allow mixed case duration strings" do
    Stretto::Pattern.new("CwHqI").first.duration.should be == Rational(8 + 4 + 2 + 1, 8) 
  end

  it "should allow case insensitive attacks and decays" do
    notes = Stretto::Pattern.new("Ca60d80 CA60d80 Ca60D80 CA60D80")
    notes.map(&:attack).should be == [60, 60, 60, 60]
    notes.map(&:decay).should be == [80, 80, 80, 80]
  end

  it "should allow case insensitive key signatures" do
    patterns = ["KGmaj F", "Kgmaj F", "kgmaj F", "KGMAJ F", "kGmaj F", "kgMAJ F", "kgmAj F"]
    patterns.each do |string|
      pattern = Stretto::Pattern.new(string)
      pattern[0].should be_an_instance_of(Stretto::MusicElements::KeySignature)
      pattern[1].pitch.should be == 66
    end
  end

  context "reading variables case insensitively" do
    it "should read already predefined variables" do
      pattern = Stretto::Pattern.new("I[cello] I[Cello] I[CeLlO]")
      pattern.elements.map(&:value).should == [42, 42, 42]
    end

    it "should read user defined variables" do
      pattern = Stretto::Pattern.new("$my_var=100 [MY_VAR] [My_var] [my_var] [mY_VaR]")
      pattern[1..-1].map(&:pitch).should be == [100, 100, 100, 100]
    end

    it "should overwrite user defined variables with different case" do
      pattern = Stretto::Pattern.new("$MY_VAR=50 [My_var] $my_var=100 [My_var]")
      pattern[1].pitch.should be == 50
      pattern[3].pitch.should be == 100
    end

    it "should overwrite predefined variables if declared one similar with different case" do
      pattern = Stretto::Pattern.new("I[Piano] $piano=42 I[Piano]")
      pattern[0].value.should be == 0
      pattern[2].value.should be == 42
    end
  end

end