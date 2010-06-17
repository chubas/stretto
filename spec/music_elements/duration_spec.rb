require File.join(File.dirname(__FILE__), '../spec_helper')

describe "note and chord durations" do

  context "duration of notes" do
    it "should retain the original duration of a note" do
      Stretto::Parser.new("Ch").to_stretto.first.original_duration.should be == 'h'
      Stretto::Parser.new("Cq").to_stretto.first.original_duration.should be == 'q'
      Stretto::Parser.new("Cw.").to_stretto.first.original_duration.should be == 'w.'
      Stretto::Parser.new("Cw...").to_stretto.first.original_duration.should be == 'w...'
      Stretto::Parser.new("C/0.5").to_stretto.first.original_duration.should be == '/0.5'
      Stretto::Parser.new("Cq*").to_stretto.first.original_duration.should be == 'q*'
      Stretto::Parser.new("Ch*3:4").to_stretto.first.original_duration.should be == 'h*3:4'
      Stretto::Parser.new("Cq*").to_stretto.first.original_duration.should be == 'q*'
    end
  end

  context "calculating decimal value of notes" do
    it "should return correctly the duration value for standard durations on notes" do
      Stretto::Parser.new("Cw").to_stretto.first.duration.should be == 1.0
      Stretto::Parser.new("Ch").to_stretto.first.duration.should be == 0.5
      Stretto::Parser.new("Cq").to_stretto.first.duration.should be == 0.25
      Stretto::Parser.new("Ci").to_stretto.first.duration.should be == 0.125
      Stretto::Parser.new("Cs").to_stretto.first.duration.should be == 0.0625
      Stretto::Parser.new("Ct").to_stretto.first.duration.should be == 0.03125
      Stretto::Parser.new("Cx").to_stretto.first.duration.should be == 0.015625
      Stretto::Parser.new("Co").to_stretto.first.duration.should be == 0.0078125
    end

    it "should return correctly the duration value for standard durations on chords" do
      Stretto::Parser.new("Cmajw").to_stretto.first.duration.should be == 1.0
      Stretto::Parser.new("Cmajh").to_stretto.first.duration.should be == 0.5
      Stretto::Parser.new("Cmajq").to_stretto.first.duration.should be == 0.25
      Stretto::Parser.new("Cmaji").to_stretto.first.duration.should be == 0.125
      Stretto::Parser.new("Cmajs").to_stretto.first.duration.should be == 0.0625
      Stretto::Parser.new("Cmajt").to_stretto.first.duration.should be == 0.03125
      Stretto::Parser.new("Cmajx").to_stretto.first.duration.should be == 0.015625
      Stretto::Parser.new("Cmajo").to_stretto.first.duration.should be == 0.0078125
    end

    it "should return decimal duration when specified by a number" do
      Stretto::Parser.new("C/1.0").to_stretto.first.duration.should be == 1.0
      Stretto::Parser.new("C/3.0").to_stretto.first.duration.should be == 3.0
      Stretto::Parser.new("C/0.0125").to_stretto.first.duration.should be == 0.0125
      Stretto::Parser.new("C/0.333333333").to_stretto.first.duration.should be == 0.333333333
      Stretto::Parser.new("C/1").to_stretto.first.duration.should be == 1
      Stretto::Parser.new("C/100").to_stretto.first.duration.should be == 100
      # TODO: Is a duration 0 possible?
      # Stretto::Parser.new("C/0").to_stretto.first.duration.should be == 0
    end

    context "when adding dot duration to notes" do

      it "should return correct duration when using a single dot" do
        Stretto::Parser.new("Cw.").to_stretto.first.duration.should be == 1.5
        Stretto::Parser.new("Ch.").to_stretto.first.duration.should be == 0.75
        Stretto::Parser.new("Cmajq.").to_stretto.first.duration.should be == 0.375
        Stretto::Parser.new("Cmaji.").to_stretto.first.duration.should be == 0.1875
      end

    end
  end

end