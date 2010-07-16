require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::MusicElements::Rest do

  context "when creating it from its string representation" do
    it "should return its duration correctly" do
      Stretto::MusicElements::Rest.new("Rw").duration.should be == 1.0
    end

    ALL_ELEMENTS.except(:rest).each do |element, string|
      it "should not parse #{element} as a rest" do
        lambda do
          Stretto::MusicElements::Rest.new(string)
        end.should raise_error(Stretto::Exceptions::ParseError, /rest/i)
      end
    end
  end

end