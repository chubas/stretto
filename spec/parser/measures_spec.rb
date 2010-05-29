require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing measures" do

  it "should parse measures" do
    Stretto::Parser.new("|").should be_valid
    Stretto::Parser.new("| |").should be_valid
    Stretto::Parser.new("||").should_not be_valid
  end

  it "should allow measure bars between notes" do
    Stretto::Parser.new("C | D | Emaj").should be_valid
  end

end