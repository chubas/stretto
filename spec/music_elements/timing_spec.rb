require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Timing do

  context "when creating ot from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        Stretto::MusicElements::Timing.new("@2000").value.should be == 2000
      end

      it "should not have a pattern attached" do
        Stretto::MusicElements::Timing.new("@2000").pattern.should be_nil
      end

      ALL_ELEMENTS.except(:timing).each do |element, string|
        it "should not parse #{element} as timing" do
          lambda do
            Stretto::MusicElements::Timing.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /timing/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        timing = Stretto::MusicElements::Timing.new("@[ALLEGRO]") # It can accept any variable
        timing.value.should be == 120
        timing.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        timing = Stretto::MusicElements::Timing.new("@[SOME_VAR]")
        lambda do
          timing.value
        end.should raise_error(Stretto::Exceptions::VariableContextException, /pattern/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=1000")
        timing = Stretto::MusicElements::Timing.new("@[SOME_VAR]")
        pattern << timing
        timing.value.should be == 1000
      end
    end

  end

end