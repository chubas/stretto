require File.dirname(__FILE__) + '/../spec_helper'

describe "parser" do

  it "sets next and prev" do
    parsed = Stretto::Parser.new("C D").to_stretto
    parsed[0].next.should == parsed[1]
    parsed[1].prev.should == parsed[0]
    parsed[0].prev.should be_nil
    parsed[1].next.should be_nil
  end
  
end
