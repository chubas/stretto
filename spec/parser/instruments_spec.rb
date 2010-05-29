require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing instrument notations" do

  it "should parse instrument in numeric notation" do
    Stretto::Parser.new("I100").should be_valid
  end

  it "should parse instruments in variable notation" do
    Stretto::Parser.new("I[PIANO]").should be_valid
    Stretto::Parser.new("I[WHATEVER_VARIABLE]").should be_valid
  end

end
