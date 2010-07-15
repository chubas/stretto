require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::PolyphonicPressure do

  context "when creating it from its string representation" do
    it "should return its pitch correctly" do
      Stretto::MusicElements::PolyphonicPressure.new("*80,100").pitch.should be == 80
    end

    it "should return its value correctly" do
      Stretto::MusicElements::PolyphonicPressure.new("*80,100").value.should be == 100
    end

    ALL_ELEMENTS.except(:polyphonic_pressure).each do |element, string|
      it "should not parse #{element} as polyphonic pressure" do
        lambda do
          Stretto::MusicElements::PolyphonicPressure.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /polyphonic pressure/i)
      end
    end
  end

  context "when using variable value notation" do
    it "should accept predefined variables" do
      pressure = Stretto::MusicElements::PolyphonicPressure.new("*[PIANO],[ALLEGRO]")
      pressure.pitch.should be == 0
      pressure.value.should be == 120
      pressure.pattern.should be_nil
    end

    it "should not accept undefined variables" do
      pattern = Stretto::Pattern.new("$SOME_VAR=60 $OTHER_VAR=80")
      pressure = Stretto::MusicElements::PolyphonicPressure.new("*[SOME_VAR],[OTHER_VAR]")
      pattern << pressure
      pressure.pitch.should be == 60
      pressure.value.should be == 80
    end
  end

end