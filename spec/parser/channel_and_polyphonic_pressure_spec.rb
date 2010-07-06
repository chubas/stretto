require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing channel and polyphonic pressures" do

  context "parsing channel pressure" do
    it "should parse channel pressure annotation" do
      Stretto::Parser.new("+100").should be_valid
    end
  end

  context "parsing polyphonic pressure" do
    it "should parse polyphonic pressure annotation" do
      Stretto::Parser.new("*30,50").should be_valid
    end

    it "should not allow only numeric values" do
      Stretto::Parser.new("*C5,30").should_not be_valid
    end

    it "should have always two arguments, separated by the comma" do
      Stretto::Parser.new("*100,").should_not be_valid
      Stretto::Parser.new("*,100").should_not be_valid
    end

    it "should allow values as variables for polyphonic pressure" do
      Stretto::Parser.new("*[SOME_VAR],10").should be_valid
      Stretto::Parser.new("*10,[SOME_VAR]").should be_valid
      Stretto::Parser.new("*[SOME_VAR],[SOME_OTHER_VAR]").should be_valid
    end
  end

end
