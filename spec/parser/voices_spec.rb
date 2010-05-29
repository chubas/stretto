require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing voices" do

  it "should parse voice (MIDI channel)" do
    Stretto::Parser.new("V1").should be_valid
  end

  # For tests on substituting notes with variables, as mentioned on the 'MIDI percussion track' of the
  # JFugue guide, refer to the 'variables_spec' test.
  context "substituting variables in V9" do
    it "should add a test for substituting variables"
  end

end
