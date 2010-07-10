require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing constants" do

  context "using constant substitutions" do
    context "parse constants wherever a number may be expected" do
      it "should allow constant in note value declaration" do
        Stretto::Parser.new("[MY_VAR]").should be_valid
        Stretto::Parser.new("[MY_VAR]w-").should be_valid
        Stretto::Parser.new("[MY_VAR]q+[OTHER_VAR]h_[MORE_VAR]w").should be_valid
      end

      it "should validates that constant names start with a letter or underscore, and contain only letters, digits and underscores" do
        Stretto::Parser.new("[Myvar]").should be_valid
        Stretto::Parser.new("[myvar]").should be_valid
        Stretto::Parser.new("[my_var]").should be_valid
        Stretto::Parser.new("[MY_VAR2]").should be_valid
        Stretto::Parser.new("[MY_VAR_]").should be_valid
        Stretto::Parser.new("[_MY_VAR]").should be_valid

        Stretto::Parser.new("[]").should_not be_valid
        Stretto::Parser.new("[4_VAR]").should_not be_valid
        Stretto::Parser.new("[*MY_VAR]").should_not be_valid
        Stretto::Parser.new("[MY_VAR~]").should_not be_valid
      end
      
      it "should allow constants in note duration definition, when using a fixed value" do
        Stretto::Parser.new("C6/[MY_VAR]").should be_valid
        Stretto::Parser.new("C6maj/[MY_VAR]").should be_valid
      end
  
      it "should allow constants in instrument, voice, layer and tempo" do
        Stretto::Parser.new("I[MY_VAR]").should be_valid
        Stretto::Parser.new("V[MY_VAR]").should be_valid
        Stretto::Parser.new("L[MY_VAR]").should be_valid
        Stretto::Parser.new("T[MY_VAR]").should be_valid
      end
  
      it "should allow constants in pitch wheel and pressure controls" do
        Stretto::Parser.new("&[MY_VAR]").should be_valid
        Stretto::Parser.new("+[MY_VAR]").should be_valid
        Stretto::Parser.new("*[MY_VAR],[ANOTHER_VAR]").should be_valid
      end
  
      it "should allow constants in attack and decay" do
        Stretto::Parser.new("C5a[MY_VAR]d[MY_VAR]").should be_valid
      end
  
      it "should allow constants in controller event definitions" do
        Stretto::Parser.new("X35=[MY_VAR]").should be_valid
        Stretto::Parser.new("X[MY_VAR]=35").should be_valid
        Stretto::Parser.new("X[MY_VAR]=[OTHER_VAR]").should be_valid
      end
    end

    context "don't allow constants in specific places where numbers are used" do
      it "should not allow mixed note and value definition, or octave definition as constant" do
        Stretto::Parser.new("Cb[MY_VAR]").should_not be_valid
      end

      it "should not allow constants in n-tuplets" do
        Stretto::Parser.new("Cq*[MY_VAR]:2").should_not be_valid
        Stretto::Parser.new("Cq*3:[MY_VAR]").should_not be_valid
        Stretto::Parser.new("Cq*[MY_VAR]:[OTHER_VAR]").should_not be_valid
      end
    end
  end

  context "setting new constants" do
    it "should allow the definition of a new numeric constant" do
      Stretto::Parser.new("$MY_VAR=100").should be_valid
      Stretto::Parser.new("$MY_VAR=0.5").should be_valid
    end

    it "should not allow definition of non-numeric values" do
      Stretto::Parser.new("$MY_VAR=notanumber").should_not be_valid
    end

    it "should not allow malformed variable names" do
      Stretto::Parser.new("BAD_VARIABLE=5").should_not be_valid
      Stretto::Parser.new("$1_BAD_VARIABLE=5").should_not be_valid
    end
  end

end
