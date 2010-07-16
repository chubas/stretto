require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Variable do

  context "when creating it from its string representation" do

    context "when using numeric notation" do
      it "should return its name correctly" do
        Stretto::MusicElements::Variable.new("$MY_VAR=100").name.should be == "MY_VAR"
      end

      it "should return its value as a wrapper variable" do
        variable = Stretto::MusicElements::Variable.new("$MY_VAR=100")
        variable.value.should be_an_instance_of(Stretto::Value)
      end

      ALL_ELEMENTS.except(:variable).each do |element, string|
        it "should not parse #{element} as a variable definition" do
          lambda do
            Stretto::MusicElements::Variable.new(string)
          end.should raise_error(Stretto::Exceptions::ParseError, /variable/i)
        end
      end
    end

    context "when using variable value notation" do
      it "should accept predefined variables" do
        variable = Stretto::MusicElements::Variable.new("$MY_VAR=[ALLEGRO]")
        variable.name.should be == "MY_VAR"
        variable.value.should be_an_instance_of(Stretto::Value)
      end

      it "should correctly set other elements' values with predefined variables" do
        pattern = Stretto::Pattern.new("")
        variable = Stretto::MusicElements::Variable.new("$MY_VAR=[ALLEGRO]")
        tempo = Stretto::MusicElements::Tempo.new("T[MY_VAR]")
        pattern << variable << tempo
        tempo.value.should be == 120
      end

      it "should throw an error when accessing its value if variable value is not a predefined value" do
        variable = Stretto::MusicElements::Variable.new("$MY_VAR=[SOME_OTHER_VAR]")
        lambda do
          variable.to_i
        end.should raise_error(Stretto::Exceptions::VariableContextException, /pattern/i)

        pattern = Stretto::Pattern.new("")
        tempo = Stretto::MusicElements::Tempo.new("T[MY_VAR]")
        pattern << variable
        lambda do
          pattern << tempo
        end.should raise_error(Stretto::Exceptions::VariableNotDefinedException, /SOME_OTHER_VAR/i)
      end
    end

  end

end