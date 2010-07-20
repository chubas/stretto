require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::ControllerChange do

  context "when creating it from its string representation" do

    context "when using numeric notation" do
      it "should return its controller correctly" do
        Stretto::MusicElements::ControllerChange.new("X100=200").controller.should be == 100
      end

      it "should return its value correctly" do
        Stretto::MusicElements::ControllerChange.new("X100=200").value.should be == 200
      end

      ALL_ELEMENTS.except(:controller_change).each do |element, string|
        it "should not parse #{element} as controller change" do
          lambda do
            Stretto::MusicElements::ControllerChange.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /controller change/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        controller_change = Stretto::MusicElements::ControllerChange.new("X[VOLUME]=[ON]")
        controller_change.controller.should be == 935
        controller_change.value.should be == 127
        controller_change.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        controller_change = Stretto::MusicElements::ControllerChange.new("X[SOME_VAR]=[OTHER_VAR]")
        lambda do
          controller_change.controller
        end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i)
        lambda do
          controller_change.value
        end.should raise_error(Stretto::Exceptions::VariableContextException, /OTHER_VAR/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=1000 $OTHER_VAR=2000")
        controller_change = Stretto::MusicElements::ControllerChange.new("X[SOME_VAR]=[OTHER_VAR]")
        pattern << controller_change
        controller_change.controller.should be == 1000
        controller_change.value.should be == 2000
      end

    end

  end

end