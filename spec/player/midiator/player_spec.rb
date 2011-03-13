require File.join(File.dirname(__FILE__), '../../spec_helper')

describe Stretto::Player do

  context "plays a single note" do

    it "with the correct pitch" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(60, anything, anything)
      midi.should_receive(:note_off).with(60, anything, anything)

      player.play("C")
    end

    it "with the correct default attack and decay" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)

      player.play("C")
    end

    it "with different attack and decay values" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 80)
      midi.should_receive(:note_off).with(anything, anything, 30)

      player.play("Ca80d30")
    end

    context "with a tempo" do

      it "that defaults to Allegro" do
        player = Stretto::Player.new(:driver => test_driver)

        player.midi.should_receive(:rest).with(0.5)

        player.play("C")
      end

      it "that is explicitly set" do
        player = Stretto::Player.new(:driver => test_driver)

        player.midi.should_receive(:rest).with(Rational(1, 3))

        player.play("T[Presto] C") # 180 bpm
      end

    end

    it "with the default channel of 0" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, 0, anything)
      midi.should_receive(:note_off).with(anything, 0, anything)

      player.play("C")
    end

    it "with a specific channel (voice)" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, 1, anything)
      midi.should_receive(:note_off).with(anything, 1, anything)

      player.play("V1 C")
    end

  end

  context "plays a chord" do

    it "with the correct pitches" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(36, anything, anything)
      midi.should_receive(:note_on).with(40, anything, anything)
      midi.should_receive(:note_on).with(43, anything, anything)
      midi.should_receive(:note_off).with(36, anything, anything)
      midi.should_receive(:note_off).with(40, anything, anything)
      midi.should_receive(:note_off).with(43, anything, anything)

      player.play("Cmaj")
    end

    it "with default attack and decay" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)

      player.play("Cmaj")
    end

    it "with a specific attack and decay" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 50)
      midi.should_receive(:note_on).with(anything, anything, 50)
      midi.should_receive(:note_on).with(anything, anything, 50)
      midi.should_receive(:note_off).with(anything, anything, 60)
      midi.should_receive(:note_off).with(anything, anything, 60)
      midi.should_receive(:note_off).with(anything, anything, 60)

      player.play("Cmaja50d60")
    end

    it "with a specific channel (voice)" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, 2, anything)
      midi.should_receive(:note_on).with(anything, 2, anything)
      midi.should_receive(:note_on).with(anything, 2, anything)
      midi.should_receive(:note_off).with(anything, 2, anything)
      midi.should_receive(:note_off).with(anything, 2, anything)
      midi.should_receive(:note_off).with(anything, 2, anything)

      player.play("V2 Cmaj")
    end

    it "using harmonic notation" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(60, anything, anything)
      midi.should_receive(:note_on).with(64, anything, anything)
      midi.should_receive(:note_on).with(67, anything, anything)
      midi.should_receive(:note_off).with(60, anything, anything)
      midi.should_receive(:note_off).with(64, anything, anything)
      midi.should_receive(:note_off).with(67, anything, anything)

      player.play("C5q+E5q+G5q")
    end

  end

  it "handles measures" do
    player = Stretto::Player.new(:driver => test_driver)

    lambda { player.play("C | D") }.should_not raise_error
  end

  it  "handles rests" do
    player = Stretto::Player.new(:driver => test_driver)

    midi = player.midi
    midi.should_receive(:note_on).never
    midi.should_receive(:rest).with(0.5)

    player.play("R")
  end

  context "handles ties" do

    it "by playing the tied note once for the correct duration" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).once
      midi.should_receive(:rest).with(0.5)

      player.play("Ci- C-i")
    end

    it "across measures" do
      player = Stretto::Player.new(:driver => test_driver)

      player.midi.should_receive(:note_on).once

      player.play("Ci- | C-i")
    end

    it "for chords" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).exactly(3).times
      midi.should_receive(:rest).with(0.5)

      player.play("Cmaji- Cmaj-i")
    end

    it "for rests" do
      player = Stretto::Player.new(:driver => test_driver)

      player.midi.should_receive(:rest).with(0.5)

      player.play("Ri- | R-i")
    end

  end

  context "plays a melody" do

    it "with notes only" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(60, anything, anything)
      midi.should_receive(:note_on).with(62, anything, anything)
      midi.should_receive(:rest).exactly(2).times.with(0.5)

      player.play("C_D")
    end

    it "with a note and a rest" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).once
      midi.should_receive(:rest).exactly(2).times.with(0.5)

      player.play("C_R")
    end

    it "with a note and a chord" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(60, anything, anything)
      midi.should_receive(:note_on).with(38, anything, anything)
      midi.should_receive(:note_on).with(42, anything, anything)
      midi.should_receive(:note_on).with(45, anything, anything)
      midi.should_receive(:rest).exactly(2).times.with(0.5)

      player.play("C_Dmaj")
    end

    context "with harmonies" do

      it "of a note and a melody" do
        player = Stretto::Player.new(:driver => test_driver)

        midi = player.midi
        midi.should_receive(:note_on).with(60, anything, anything).ordered # C
        midi.should_receive(:note_on).with(64, anything, anything).ordered # E
        midi.should_receive(:note_off).with(64, anything, anything).ordered # E
        midi.should_receive(:note_on).with(67, anything, anything).ordered # G
        midi.should_receive(:note_off).with(60, anything, anything).ordered # C
        midi.should_receive(:note_off).with(67, anything, anything).ordered # G

        player.play("C5h+E5q_G5q")
      end

    end
    
  end

  it  "handles channel pressure" do
    player = Stretto::Player.new(:driver => test_driver)

    midi = player.midi
    midi.should_receive(:channel_aftertouch).with(0, 60)

    player.play("+60")
  end

  it "handles instrument" do
    player = Stretto::Player.new(:driver => test_driver)

    midi = player.midi
    midi.should_receive(:program_change).with(0, 24)

    player.play("V0 I[GUITAR] Cmaj")
  end

  context "handles voices and layers" do

    it "handles multiple voices simultaneously" do
      player = Stretto::Player.new(:driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).twice.ordered
      midi.should_receive(:note_off).twice.ordered

      player.play("V0 C5 V1 E5")
    end

    it "plays layers in the correct order and the same voice" do
      player = Stretto::Player.new(:driver => test_driver)
      midi = player.midi
      midi.should_receive(:note_on).with(60, 0, anything).ordered
      midi.should_receive(:note_on).with(64, 1, anything).ordered
      midi.should_receive(:note_on).with(60, 0, anything).ordered
      midi.should_receive(:note_on).with(64, 1, anything).ordered

      player.play(<<-LAYERS)
        V0 L0 Ch
           L1 Rq    Cq
        V1 L0 Ri Ei
           L1 Rq.      Ei
      LAYERS
    end
  end

end
