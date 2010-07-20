require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::LayerChange do

  context "when creating it from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        Stretto::MusicElements::LayerChange.new("L5").index.should be == 5
      end

      ALL_ELEMENTS.except(:layer_change).each do |element, string|
        it "should not parse #{element} as layer change" do
          lambda do
            Stretto::MusicElements::LayerChange.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /layer change/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        layer_change = Stretto::MusicElements::LayerChange.new("L[PIANO]")
        layer_change.index.should be == 0
        layer_change.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        layer_change = Stretto::MusicElements::LayerChange.new("L[SOME_VAR]")
        lambda do
          layer_change.index
        end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=4")
        layer_change = Stretto::MusicElements::LayerChange.new("L[SOME_VAR]")
        pattern << layer_change
        layer_change.index.should be == 4
      end
    end

  end

end