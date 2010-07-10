require File.dirname(__FILE__) + '/../spec_helper'

describe "tempo changes" do

  it "should return tempo changes as elements in a composition" do
    pattern = Stretto::Pattern.new("T120 C D E T140 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::Tempo)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::Tempo)
  end

  it "should not allow a tempo equals to 0?"

  it "should return correctly its value" do
    tempos = Stretto::Pattern.new("T120 T140")
    tempos[0].value.should be == 120
    tempos[1].value.should be == 140
  end

  it "should respond to the method :bpm and return its value" do
    tempo = Stretto::Pattern.new("T120")[0]
    tempo.should respond_to(:bpm)
    tempo.bpm.should be == 120
  end

  it "should correctly return its value if given as a variable" do
    Stretto::Pattern.new("$MY_VAR=150 T[MY_VAR]")[1].value.should be == 150
  end

end