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

  context "when using predefined values for percussion track" do
    it "should accept the percussion predefined variables" do
        Stretto::Pattern.new(<<-PERCUSSION).map(&:pitch).should be == [*35..81]
          [ACOUSTIC_BASE_DRUM] [BASS_DRUM] [SIDE_KICK] [ACOUSTIC_SNARE] [HAND_CLAP] [ELECTRIC_SNARE] [LOW_FLOOR_TOM]
          [CLOSED_HI_HAT] [HIGH_FLOOR_TOM] [PEDAL_HI_TOM] [LOW_TOM] [OPEN_HI_HAT] [LOW_MID_TOM] [HI_MID_TOM]
          [CRASH_CYMBAL_1] [HIGH_TOM] [RIDE_CYMBAL_1] [CHINESE_CYMBAL] [RIDE_BELL] [TAMBOURINE] [SPLASH_CYMBAL]
          [COWBELL] [CRASH_CYMBAL_2] [VIBRASLAP] [RIDE_CYMBAL_2] [HI_BONGO] [LOW_BONGO] [MUTE_HI_CONGA]
          [OPEN_HI_CONGA] [LOW_CONGO] [HIGH_TIMBALE] [LOW_TIMBALE] [HIGH_AGOGO] [LOW_AGOGO] [CABASA] [MARACAS]
          [SHORT_WHISTLE] [LONG_WHISTLE] [SHORT_GUIRO] [LONG_GUIRO] [CLAVES] [HI_WOOD_BLOCK] [LOW_WOOD_BLOCK]
          [MUTE_CUICA] [OPEN_CUICA] [MUTE_TRIANGLE] [OPEN_TRIANGLE]
        PERCUSSION
      end
  end

  # TODO: maybe do element linking in Voice...
  it "should tie correctly notes separated by a voice"
  it "should adjust correctly the next and prev elements of voice elements"
  
  # PENDING: Does pattern return duration at all?
  it "should return correctly a per-voice duration"
end
