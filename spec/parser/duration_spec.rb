require File.join(File.dirname(__FILE__), '../spec_helper')

describe "parsing durations" do

  context "reading the allowed durations a note can have" do
    it "should allow valid durations" do
      %w|w h q i s t x o|.each do |duration|
        Stretto::Parser.new("C" + duration).should be_valid
      end
    end
  end

  context "reading duration after a music element" do
    it "should allow duration after a note or a rest" do
      Stretto::Parser.new("Cw").should be_valid
      Stretto::Parser.new("Rw").should be_valid
    end

    it "should allow duration after a chord" do
      Stretto::Parser.new("Cmajw")
    end
  end

  context "reading dotted durations" do
    it "should allow dotted durations" do
      Stretto::Parser.new("Cw.").should be_valid
    end

    it "should allow more than one duration dot" do
      Stretto::Parser.new("Cw..").should be_valid

      # While technically correct, more than three dots are not used in practice. Stretto should
      # allow them anyway (See http://en.wikipedia.org/wiki/Dotted_note#Triple_dotting)
      Stretto::Parser.new("Cw....").should be_valid
    end
  end

  context "reading numeric durations" do
    it "should allow numeric duration values" do
      Stretto::Parser.new("C/0.25").should be_valid
      Stretto::Parser.new("C/4.3333").should be_valid
      Stretto::Parser.new("Cmaj7/0.25").should be_valid
      Stretto::Parser.new("C/1").should be_valid
    end

    it "should not allow dotted duration with numeric values" do
      Stretto::Parser.new("C/0.25.").should_not be_valid
      Stretto::Parser.new("Cmaj/1.").should_not be_valid
    end
  end

  context "reading n-tuplets" do
    it "should allow triplets (default value)" do
      Stretto::Parser.new("Cq*").should be_valid
      Stretto::Parser.new("Cmaj7q*").should be_valid
    end

    it "should allow n-tuplets by specifying ratio" do
      Stretto::Parser.new("Ci*5:4").should be_valid
      Stretto::Parser.new("Cmaj7i*5:4").should be_valid
    end

    it "should allow tuplets on dotted duration notes" do
      Stretto::Parser.new("Cw.*3:4").should be_valid
    end

    it "should not allow tuplets in notes with decimal value duration" do
      Stretto::Parser.new("C/0.15*").should_not be_valid
      Stretto::Parser.new("C/1*").should_not be_valid
      Stretto::Parser.new("C/1.0*3:4").should_not be_valid
    end

    # TODO: Check this
    it "should not allow tuplets in notes with the default duration" do
      Stretto::Parser.new("C*").should_not be_valid
      Stretto::Parser.new("Cmaj*").should_not be_valid
      Stretto::Parser.new("C*5:4").should_not be_valid
    end
  end

  context "concatenating duration values" do
    it "should allow concatenated notes" do
      Stretto::Parser.new("Cwq").should be_valid
      Stretto::Parser.new("Ciiiii").should be_valid
      Stretto::Parser.new("Cwq..").should be_valid
    end

    it "should not allow dot after tuplet" do
      Stretto::Parser.new("Cw*3:4.").should_not be_valid
    end

    it "should not allow concatenated tuplets" do
      Stretto::Parser.new("Cw*3:4*3:4").should_not be_valid
    end
  end
end
