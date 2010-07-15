require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Tempo do

  context "when creating ot from its string representation" do

    context "when using numeric notation" do
      it "should return its value correctly" do
        tempo = Stretto::MusicElements::Tempo.new("T140")
        tempo.value.should be == 140
        tempo.bpm.should be == 140
      end

      it "should not have a pattern attached" do
        Stretto::MusicElements::Tempo.new("T140").pattern.should be_nil
      end

      ALL_ELEMENTS.except(:tempo).each do |element, string|
        it "should not parse #{element} as tempo" do
          lambda do
            Stretto::MusicElements::Tempo.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /tempo/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        tempo = Stretto::MusicElements::Tempo.new("T[ALLEGRO]")
        tempo.value.should be == 120
        tempo.bpm.should be == 120
        tempo.pattern.should be_nil
      end

      it "should not accept undefined variables" do
        tempo = Stretto::MusicElements::Tempo.new("T[SOME_VAR]")
        lambda do
          tempo.bpm
        end.should raise_error(Stretto::Exceptions::VariableContextException, /pattern/i)
      end

      it "should accept variables when attaching to a pattern" do
        pattern = Stretto::Pattern.new("$SOME_VAR=80")
        tempo = Stretto::MusicElements::Tempo.new("T[SOME_VAR]")
        pattern << tempo
        tempo.value.should be == 80
      end
    end

  end

end