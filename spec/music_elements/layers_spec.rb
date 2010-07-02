require File.join(File.dirname(__FILE__), '/../spec_helper')

describe "layers" do

  it "should return layer changes as music elements" do
    pattern = Stretto::Pattern.new("L0 C D E L1 F G A")
    pattern[0].should be_an_instance_of(Stretto::MusicElements::LayerChange)
    pattern[4].should be_an_instance_of(Stretto::MusicElements::LayerChange)
  end

  it "should not allow a voice over 15" do
    lambda{ Stretto::Pattern.new("L15 C D E") }.should_not raise_error
    lambda{ Stretto::Pattern.new("L16 C D E") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /layer/i)
  end

  it "should correctly separate the pattern when accesed its layer elements" do
    pattern = Stretto::Pattern.new("L0 C D E L1 F G A")
    pattern.should have(8).elements
    pattern.voice(0).layer(0).should have(3).elements
    pattern.voice(0).layer(1).should have(3).elements
  end

  it "should return layers as a hash, with layer index as a key" do
    voice = Stretto::Pattern.new("L1 C D E L2 F G A").voice(0)
    voice.layers[0].should be_nil
    voice.layers[1].should be_an_instance_of(Stretto::Layer)
    voice.layers[2].should be_an_instance_of(Stretto::Layer)
    voice.layers[3].should be_nil
  end

  it "should parse correctly the index of a layer" do
    voice = Stretto::Pattern.new("L10 C D E").voice(0)
    voice.layers[10].should_not be_nil
  end

end

describe "layer objects" do
  it "should be part of a voice" do
    voice = Stretto::Pattern.new("V0 L0 C D E").voice(0)
    voice.layer(0).should be_an_instance_of(Stretto::Layer)
  end

  it "should respond to the :elements method returning its elements" do
    layer = Stretto::Pattern.new("V0 L0 C D E").voice(0).layer(0)
    layer.should respond_to(:elements)
    layer.should have(3).elements
  end

  it "should correctly separate elements in a layer" do
    voice = Stretto::Pattern.new("V0 L0 C D E L1 F G A").voice(0)
    voice.layer(0).should have(3).elements
    voice.layer(1).should have(3).elements
  end

  it "should correctly separate layers from different voices" do
    pattern = Stretto::Pattern.new("V0 L0 C D E V1 L0 Cmaj Dmaj Emaj")
    pattern.voice(0).should have(1).layers
    pattern.voice(0).layer(0).should have(3).elements
    pattern.voice(1).should have(1).layers
    pattern.voice(1).layer(0).should have(3).elements
  end

  it "should parse correctly different layers in a no contiguous same voice" do
    voice = Stretto::Pattern.new("V0 L0 C D E V1 Cmaj Dmaj Emaj V0 L0 F G A").voice(0)
    voice.layer(0).should have(6).elements
  end

  it "should use the layer 0 by default if it is not specified" do
    voice = Stretto::Pattern.new("V0 C D E").voice(0)
    voice.layer(0).should be_an_instance_of(Stretto::Layer)
  end

  it "should join layers separated by another layer between" do
    voice = Stretto::Pattern.new("V0 L0 C D E L1 Cmin Dmin Emin L0 F G A").voice(0)
    voice.layer(0).should have(6).elements
  end

  # TODO: Not sure about this. Do we need this functionality?
  it "should tie notes correctly when separated by a layer"
  it "should adjust correctly the next and prev elements in layer's elements"
  it "should return correctly a per-voice duration"
end
