require File.join(File.dirname(__FILE__), '../spec_helper')

describe "note and chord durations" do

  context "duration of notes" do
    it "should retain the original duration of a note" do
      Stretto::Pattern.new("Ch").first.original_duration.should be == 'h'
      Stretto::Pattern.new("Cq").first.original_duration.should be == 'q'
      Stretto::Pattern.new("Cw.").first.original_duration.should be == 'w.'
      Stretto::Pattern.new("Cw...").first.original_duration.should be == 'w...'
      Stretto::Pattern.new("C/0.5").first.original_duration.should be == '/0.5'
      Stretto::Pattern.new("Cq*").first.original_duration.should be == 'q*'
      Stretto::Pattern.new("Ch*3:4").first.original_duration.should be == 'h*3:4'
      Stretto::Pattern.new("Cq*").first.original_duration.should be == 'q*'
    end
  end

  context "calculating decimal value of notes" do
    it "should return correctly the duration value for standard durations on notes" do
      Stretto::Pattern.new("Cw").first.duration.should be == 1.0
      Stretto::Pattern.new("Ch").first.duration.should be == 0.5
      Stretto::Pattern.new("Cq").first.duration.should be == 0.25
      Stretto::Pattern.new("Ci").first.duration.should be == 0.125
      Stretto::Pattern.new("Cs").first.duration.should be == 0.0625
      Stretto::Pattern.new("Ct").first.duration.should be == 0.03125
      Stretto::Pattern.new("Cx").first.duration.should be == 0.015625
      Stretto::Pattern.new("Co").first.duration.should be == 0.0078125
    end

    it "should return correctly the duration value for standard durations on chords" do
      Stretto::Pattern.new("Cmajw").first.duration.should be == 1.0
      Stretto::Pattern.new("Cmajh").first.duration.should be == 0.5
      Stretto::Pattern.new("Cmajq").first.duration.should be == 0.25
      Stretto::Pattern.new("Cmaji").first.duration.should be == 0.125
      Stretto::Pattern.new("Cmajs").first.duration.should be == 0.0625
      Stretto::Pattern.new("Cmajt").first.duration.should be == 0.03125
      Stretto::Pattern.new("Cmajx").first.duration.should be == 0.015625
      Stretto::Pattern.new("Cmajo").first.duration.should be == 0.0078125
    end

    it "should return decimal duration when specified by a number" do
      Stretto::Pattern.new("C/1.0").first.duration.should be == 1.0
      Stretto::Pattern.new("C/3.0").first.duration.should be == 3.0
      Stretto::Pattern.new("C/0.0125").first.duration.should be == 0.0125
      Stretto::Pattern.new("C/0.333333333").first.duration.should be == 0.333333333
      Stretto::Pattern.new("C/1").first.duration.should be == 1
      Stretto::Pattern.new("C/100").first.duration.should be == 100
      Stretto::Pattern.new("C/0").first.duration.should be == 0
    end

    it "should return correct decimal duration when using concatenated duration characters" do
      Stretto::Pattern.new("Cww").first.duration.should be == 2.0
      Stretto::Pattern.new("Chh").first.duration.should be == 1.0
      Stretto::Pattern.new("Cwh").first.duration.should be == 1.5
      Stretto::Pattern.new("Chw").first.duration.should be == 1.5
      Stretto::Pattern.new("Cwhq").first.duration.should be == 1.75
      Stretto::Pattern.new("Chqw").first.duration.should be == 1.75
    end

    context "when adding dot duration to notes" do
      it "should return correct duration when using a single dot" do
        Stretto::Pattern.new("Cw.").first.duration.should be == 1.5
        Stretto::Pattern.new("Ch.").first.duration.should be == 0.75
        Stretto::Pattern.new("Cmajq.").first.duration.should be == 0.375
        Stretto::Pattern.new("Cmaji.").first.duration.should be == 0.1875
      end

      it "should arbitrarily accept more than one dot" do
        Stretto::Pattern.new("Cw..").first.duration.should be == 1.75
        Stretto::Pattern.new("Cw...").first.duration.should be == 1.875
        Stretto::Pattern.new("Cmajw..").first.duration.should be == 1.75
        Stretto::Pattern.new("Cmajw...").first.duration.should be == 1.875
      end
    end

    context "when adding tuplet duration to notes" do
      it "should return correct duration when using tuplets in single duration characters" do
        Stretto::Pattern.new("Cq*").first.duration.should be == Rational(1, 6) # Two thirds ot 1 / 4
        Stretto::Pattern.new("Cq* Cq* Cq*").map(&:duration).sum.should be == Rational(1, 2)
      end

      it "should return correct duration when using tuplets in multiple duration characters" do
        Stretto::Pattern.new("Chh*").first.duration.should be == Rational(2, 3)
        Stretto::Pattern.new("Chq*").first.duration.should be == 0.5
      end

      it "should return correct duration when using n-tuplets" do
        Stretto::Pattern.new("Cq*3:2").first.duration.should be == Rational(1, 6)
        Stretto::Pattern.new("Cw*5:4").first.duration.should be == Rational(4, 5)
        Stretto::Pattern.new("Cw*4:5").first.duration.should be == Rational(5, 4)
      end

      it "should return correct duration when using tuplets in dotted notes" do
        Stretto::Pattern.new("Ch.*").first.duration.should be     == 0.5
        Stretto::Pattern.new("Ch.*5:4").first.duration.should be  == 0.6
      end
    end

    it "should return correctly the duration value for rests" do
      Stretto::Pattern.new("Rw").first.duration.should be == 1.0
      Stretto::Pattern.new("Rh").first.duration.should be == 0.5
      Stretto::Pattern.new("Rw.").first.duration.should be == 1.5
      Stretto::Pattern.new("Rq*").first.duration.should be == Rational(1, 6)
      Stretto::Pattern.new("R/1.5").first.duration.should be == 1.5
    end

    context "when using literal duration value" do
      it "should return correct duration when using a named variable duration"
    end
  end
end