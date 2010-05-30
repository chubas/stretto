require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing pitch wheel annotation" do

  it "should parse pitch wheel with numeric notation" do
    Stretto::Parser.new("&0").should be_valid
    Stretto::Parser.new("&1500").should be_valid
    Stretto::Parser.new("&8192").should be_valid
  end

end
