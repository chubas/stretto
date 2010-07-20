require File.dirname(__FILE__) + '/../spec_helper'

context "when creating it from its string representation" do

  context "when using numeric notation" do
    it "should return its value correctly" do
      Stretto::MusicElements::VoiceChange.new("V5").index.should be == 5
    end

    ALL_ELEMENTS.except(:voice_change).each do |element, string|
      it "should not parse #{element} as layer change" do
        lambda do
          Stretto::MusicElements::VoiceChange.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /voice change/i)
      end
    end
  end

  context "when using variable value notation" do
    it "should accept predefined variables" do
      voice_change = Stretto::MusicElements::VoiceChange.new("V[PIANO]")
      voice_change.index.should be == 0
      voice_change.pattern.should be_nil
    end

    it "should should not accept undefined variables" do
      voice_change = Stretto::MusicElements::VoiceChange.new("V[SOME_VAR]")
      lambda do
        voice_change.index
      end.should raise_error(Stretto::Exceptions::VariableContextException, /SOME_VAR/i)
    end

    it "should accept variables when attaching to a pattern" do
      pattern = Stretto::Pattern.new("$SOME_VAR=4")
      voice_change = Stretto::MusicElements::VoiceChange.new("V[SOME_VAR]")
      pattern << voice_change
      voice_change.index.should be == 4
    end
  end

end