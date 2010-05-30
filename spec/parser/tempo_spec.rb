require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing voices" do

  it "should parse tempo with numeric notation" do
    Stretto::Parser.new("T120").should be_valid
    end

  it "should parse tempo with variable notation" do
    Stretto::Parser.new("T[ALLEGRO]").should be_valid
    Stretto::Parser.new("T[SOME_TEMPO]").should be_valid
  end

end
