require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Measure do

  it "should be parsed from its string representation" do
    Stretto::MusicElements::Measure.new('|').should be_an_instance_of(Stretto::MusicElements::Measure)
  end
  
  ALL_ELEMENTS.except(:measure).each do |element, string|
    it "should not parse #{element} as measure" do
      lambda do
        Stretto::MusicElements::Measure.new(string)
      end.should raise_error(Stretto::Exceptions::ParseError, /measure/i)
    end
  end
  
end