require File.dirname(__FILE__) + '/../spec_helper'

describe "music pattern" do

  context "when acting like a linked list of music elements" do

    it "should allow transversal of music elements as a linked list" do
      note = Stretto::Pattern.new("C R Cmaj").first
      note.prev.should be_nil
      note.should be_instance_of(Stretto::MusicElements::Note)

      rest = note.next
      rest.should_not be_nil
      rest.should be_instance_of(Stretto::MusicElements::Rest)
      rest.prev.should == note

      chord = rest.next
      chord.should_not be_nil
      chord.should be_instance_of(Stretto::MusicElements::Chord)
      chord.prev.should == rest
      chord.next.should be_nil
    end

  end

end