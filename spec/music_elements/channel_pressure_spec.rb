require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::ChannelPressure do

  context "when creating ot from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        Stretto::MusicElements::ChannelPressure.new("+100").value.should be == 100
      end

      it "should not have a pattern attached" do
        Stretto::MusicElements::ChannelPressure.new("+100").pattern.should be_nil
      end

      ALL_ELEMENTS.except(:channel_pressure).each do |element, string|
        it "should not parse #{element} as channel pressure" do
          lambda do
            Stretto::MusicElements::ChannelPressure.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /channel pressure/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        channel_pressure = Stretto::MusicElements::ChannelPressure.new("+[ALLEGRO]")
        channel_pressure.value.should be == 120
        channel_pressure.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        channel_pressure = Stretto::MusicElements::ChannelPressure.new("+[SOME_VAR]")
        lambda do
          channel_pressure.value
        end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=80")
        channel_pressure = Stretto::MusicElements::ChannelPressure.new("+[SOME_VAR]")
        pattern << channel_pressure
        channel_pressure.value.should be == 80
      end
    end

  end

end