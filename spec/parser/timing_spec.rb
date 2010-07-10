require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing timing information" do
  it "should parse timing information with numeric value" do
    Stretto::Parser.new("@2000").should be_valid
  end

  it "should parse timing information with a variable" do
    Stretto::Parser.new("@[MY_VAR]").should be_valid
  end
end