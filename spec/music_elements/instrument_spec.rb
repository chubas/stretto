require File.dirname(__FILE__) + '/../spec_helper'

describe "handling instruments" do

  it "should parse instrument as a music element" do
    Stretto::Pattern.new("I100").first.should be_an_instance_of(Stretto::MusicElements::Instrument)
  end

  it "should assign an instrument to the music element being played" do
    note = Stretto::Pattern.new("I100 C5")[1]
    note.instrument.should_not be_nil
    note.instrument.value.should be == 100
  end

  it "should use the default intrument of 0 if not present" do
    Stretto::Pattern.new("C5").first.instrument.value.should be == 0
  end

  context "when using literal (numeric) value" do
    it "should return the correct value" do
      Stretto::Pattern.new("I100").first.value.should be == 100
    end

    it "should not allow a value higher than 127" do
      lambda { Stretto::Pattern.new("I127") }.should_not raise_error
      lambda { Stretto::Pattern.new("I128") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /instrument/i)
    end
  end

  context "when using variable value" do
    it "should return the correct value" do
      Stretto::Pattern.new("$MY_VAR=20 I[MY_VAR]")[1].value.should be == 20
    end

    it "should not allow a value higher than 127" do
      lambda{ Stretto::Pattern.new("$MY_VALUE=128 I[MY_VALUE]") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /instrument/i)
    end

    it "should accept the predefined variables according to the JFugue guide"
  end

  context "when using multiple voices in a composition" do
    it "should not affect the instrument of other voices" do
      pattern = Stretto::Pattern.new("V0 I80 C V1 D")
      pattern[2].instrument.value.should be == 80
      pattern[4].instrument.value.should be == 0
    end

    it "should change the instrument per voice effectively" do
      pattern = Stretto::Pattern.new("V0 I50 C V1 Dmaj V0 I60 E V1 I80 Fmaj")
      pattern[2].instrument.value.should be == 50
      pattern[4].instrument.value.should be == 0
      pattern[7].instrument.value.should be == 60
      pattern[10].instrument.value.should be == 80
    end

    it "should use the same instrument per voice even if in different layers?"
    # TODO: What happens for example in "V0 L0 I80 C I100 D" ?

  end

end