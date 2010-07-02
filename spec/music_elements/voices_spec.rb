require File.dirname(__FILE__) + '/../spec_helper'

describe "voice changes" do
  it "should return voice changes as elements in a composition" do
    pattern = Stretto::Pattern.new("V0 C D E V1 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::VoiceChange)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::VoiceChange)
  end

  it "should not allow a voice over 15" do
    lambda{ Stretto::Pattern.new("V15 C D E") }.should_not raise_error
    lambda{ Stretto::Pattern.new("V16 C D E") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /voice/i)
  end

  it "should separate correctly the pattern when accessed its voice elements" do
    pattern = Stretto::Pattern.new("V0 C D E V1 F G A")
    pattern.should have(2).voices
  end

  it "should return voices as a hash, with voice index as key" do
    Stretto::Pattern.new("C D E").voices.should be_an_instance_of(Hash)
    Stretto::Pattern.new("V10 C D E").voices.should have_key(10)
  end

  it "should be accessed by the :voice method on pattern" do
    pattern = Stretto::Pattern.new("C D E")
    pattern.voices[0].should be == pattern.voice(0)
  end

  it "should parse correctly the index of the voice" do
    voices = Stretto::Pattern.new("V3 C D E V4 F G A").voices
    voices[0].should be_nil
    voices[3].should be_an_instance_of(Stretto::Voice)
    voices[4].should be_an_instance_of(Stretto::Voice)
    voices[5].should be_nil
  end

  it "should create voices even if empty" do
    voices = Stretto::Pattern.new("V0 C D E V1 V2 V3").voices
    voices[0].should_not be_nil
    voices[1].should_not be_nil
    voices[2].should_not be_nil
    voices[3].should_not be_nil
  end
end

describe "voice objects" do

  it "should respond to the :elements method returning its elements" do
    voice = Stretto::Pattern.new("V0 C D E").voice(0)
    voice.should respond_to(:elements)
    voice.elements.should_not be_nil
  end

  it "should correctly separate elements in a voice" do
    voices = Stretto::Pattern.new("V0 C D E V1 F G A B").voices
    voices[0].should have(3).elements
    voices[1].should have(4).elements
  end

  it "should use the voice 0 by default if not specified" do
    pattern = Stretto::Pattern.new("C D E F G")
    pattern.voices[0].should be_an_instance_of(Stretto::Voice)
  end

  it "should be continue with the given voice if interrupted by another voice" do
    pattern = Stretto::Pattern.new("V0 C D E V1 Cmaj Dmaj Emaj V0 F G A")
    pattern.should have(2).voices
    pattern.voices[0].should have(6).elements
  end

  # TODO: Not sure about this. What is better approach?
  it "should tie correctly notes separated by a voice"
  it "should adjust correctly the next and prev elements of voice elements"

  # PENDING: Does pattern return duration at all?
  it "should return correctly a per-voice duration"
end