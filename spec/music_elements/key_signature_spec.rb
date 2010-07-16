require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::KeySignature do

  context "when creating it from its string representation" do
    it "should return its scale correctly" do
      Stretto::MusicElements::KeySignature.new("KCmaj").scale.should be == :major
    end
    it "should return its key correctly" do
      Stretto::MusicElements::KeySignature.new("KCmaj").key.should be == 'C'
    end

    ALL_ELEMENTS.except(:key_signature).each do |element, string|
      it "should not parse #{element} as key signature" do
        lambda do
          Stretto::MusicElements::KeySignature.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /key signature/i)
      end
    end
  end

end