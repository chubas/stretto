require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing layers" do

  it "should parse layer" do
    Stretto::Parser.new("L1").should be_valid
  end

end
