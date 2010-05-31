require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing key signatures" do

  it "should parse key signatures" do
    Stretto::Parser.new("KCmaj").should be_valid
    Stretto::Parser.new("KCbmaj").should be_valid
    Stretto::Parser.new("KCmin").should be_valid
    Stretto::Parser.new("KCbmin").should be_valid
  end

  it "should always require note, followed by maj or min in a key signature" do
    Stretto::Parser.new("KC").should_not be_valid
    Stretto::Parser.new("Kmaj").should_not be_valid
  end

    it "should not accept duration with time signatures" do
      Stretto::Parser.new("KCwmaj").should_not be_valid
    end

    it "should not accept octaves with time signatures" do
      Stretto::Parser.new("KC3").should_not be_valid
  end

end