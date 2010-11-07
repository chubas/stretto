require File.dirname(__FILE__) + '/../spec_helper'

describe Stretto::Pattern do

  context "when acting like a linked list of music elements" do
    it "allows transversal of music elements as a linked list" do
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

  context "when initializing with a music string" do
    it "builds a new Pattern when it is valid" do
      lambda{ Stretto::Pattern.new("C7 Rq") }.should_not raise_error
    end

    it "raises an error when it is invalid" do
      lambda{ Stretto::Pattern.new("#C I5") }.should raise_error(/invalid/i)
    end

    it "indicates the character at where the error is" do
      lambda{ Stretto::Pattern.new("C#4C I5") }.should raise_error(/character 3/)
      lambda{ Stretto::Pattern.new("A B I C") }.should raise_error(/character 5/) # After the I, expects a value
    end
  end

  context "when initializing with a File object" do
    it "reads the file and parses correctly the pattern" do
      pattern = Stretto::Pattern.new(File.open(File.dirname(__FILE__) + '/../entertainer.jfugue'))
      pattern.first.should be_an_instance_of(Stretto::MusicElements::VoiceChange)
      pattern.last.should be_an_instance_of(Stretto::MusicElements::Rest)
    end
  end

  context "when initializing with an invalid File object" do
    it "raises an error in the line where it occurred" # Make file parser error-aware?
  end

end