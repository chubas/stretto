require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing controller changes" do
  it "should allow controller value change with numeric notation" do
    Stretto::Parser.new("X25=30").should be_valid
    Stretto::Parser.new("X25=[MY_VAR]").should be_valid
  end

  it "should allow controller value change with variable notation" do
    Stretto::Parser.new("X[MY_VAR]=30").should be_valid
    Stretto::Parser.new("X[MY_VAR]=30").should be_valid
  end
end