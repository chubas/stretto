require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::PitchWheel do

  context "when creating ot from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        Stretto::MusicElements::PitchWheel.new("&100").value.should be == 100
      end

      it "should not have a pattern attached" do
        Stretto::MusicElements::PitchWheel.new("&100").pattern.should be_nil
      end

      ALL_ELEMENTS.except(:pitch_wheel).each do |element, string|
        it "should not parse #{element} as pitch wheel" do
          lambda do
            Stretto::MusicElements::PitchWheel.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /pitch wheel/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        pitch_wheel = Stretto::MusicElements::PitchWheel.new("&[ALLEGRO]")
        pitch_wheel.value.should be == 120
        pitch_wheel.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        pitch_wheel = Stretto::MusicElements::PitchWheel.new("&[SOME_VAR]")
        lambda do
          pitch_wheel.value
        end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=80")
        pitch_wheel = Stretto::MusicElements::PitchWheel.new("&[SOME_VAR]")
        pattern << pitch_wheel
        pitch_wheel.value.should be == 80
      end
    end

  end

end