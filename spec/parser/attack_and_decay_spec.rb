require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing attack and decay velocities" do

  context "reading attack values" do
    it "should parse attack values" do
      Stretto::Parser.new("C5a100").should be_valid
      Stretto::Parser.new("Cmaja100").should be_valid
    end
  end

  context "reading decay values" do
    it "should parse decay values" do
      Stretto::Parser.new("C5d100").should be_valid
      Stretto::Parser.new("Cmajd100").should be_valid
    end
  end

  context "reading attack and delay in the same note" do
    it "should allow attack and delay combined" do
      Stretto::Parser.new("C5a100d100").should be_valid
      Stretto::Parser.new("Cmaja100d100").should be_valid
    end

    # NOTE: Does it affect the semantics that they can be in any order? So programs could send
    # these parameters independently.
    it "should always have attack before delay if both are present" do
      Stretto::Parser.new("C5d100a100").should_not be_valid
      Stretto::Parser.new("Cmajd100a100").should_not be_valid
    end
  end

  context "using attack and decay velocities with variables" do
    it "should accept attack velocity as a variable" do
      Stretto::Parser.new("Ca[SOMEVAR]").should be_valid
    end

    it "should accept decay velocity as a variable" do
      Stretto::Parser.new("Cd[SOMEVAR]").should be_valid
    end

    it "should accept attack and decay velocities as variables" do
      Stretto::Parser.new("Ca[SOMEVAR]d[SOMEOTHERVAR]").should be_valid
    end
  end

  it "should not accept attack nor decay on rests" do
    Stretto::Parser.new("Ra100").should_not be_valid
    Stretto::Parser.new("Rd100").should_not be_valid
    Stretto::Parser.new("Ra100d100").should_not be_valid
  end

end
