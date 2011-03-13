require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::PitchBend do

  context "when creating ot from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        Stretto::MusicElements::PitchBend.new("&100").value.should be == 100
      end

      it "should not have a pattern attached" do
        Stretto::MusicElements::PitchBend.new("&100").pattern.should be_nil
      end

      ALL_ELEMENTS.except(:pitch_bend).each do |element, string|
        it "should not parse #{element} as pitch bend" do
          lambda do
            Stretto::MusicElements::PitchBend.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /pitch bend/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        pitch_bend = Stretto::MusicElements::PitchBend.new("&[ALLEGRO]")
        pitch_bend.value.should be == 120
        pitch_bend.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        pitch_bend = Stretto::MusicElements::PitchBend.new("&[SOME_VAR]")
        lambda do
          pitch_bend.value
        end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=80")
        pitch_bend = Stretto::MusicElements::PitchBend.new("&[SOME_VAR]")
        pattern << pitch_bend
        pitch_bend.value.should be == 80
      end
    end

  end

end