require File.dirname(__FILE__) + '/../spec_helper'

describe "handling instruments" do

  it "should parse instrument as a music element" do
    Stretto::Pattern.new("I100").first.should be_an_instance_of(Stretto::MusicElements::Instrument)
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
    it "should not affect the instrtument of other voices"
    it "should reset the instrument per voice effectively"
  end

end