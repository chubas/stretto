require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Instrument do

  context "when creating it from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        Stretto::MusicElements::Instrument.new("I80").value.should be == 80
      end

      it "should not have a pattern attached" do
        Stretto::MusicElements::Instrument.new("I80").pattern.should be_nil
      end

      # OPTIMIZE: Use should each for testing multiple elements. See http://blog.thoughtfolder.com/2008-11-05-rspec-should-each-matcher.html
      ALL_ELEMENTS.except(:instrument).each do |element, string|
        it "should not parse #{element} as instrument" do
          lambda do
            Stretto::MusicElements::Instrument.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /instrument/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        instrument = Stretto::MusicElements::Instrument.new("I[PIANO]")
        instrument.value.should be == 0
        instrument.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        instrument = Stretto::MusicElements::Instrument.new("I[SOME_VAR]")
        lambda do
          instrument.value
        end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=80")
        instrument = Stretto::MusicElements::Instrument.new("I[SOME_VAR]")
        pattern << instrument
        instrument.value.should be == 80
      end
    end

  end

end