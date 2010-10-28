require File.join(File.dirname(__FILE__), '../spec_helper')

describe "player" do

  context "plays a single note" do

    it "with the correct pitch" do
      # TODO: using mac only driver!
      player = Stretto::MIDIator::Player.new("C", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(60, anything, anything)
      midi.should_receive(:note_off).with(60, anything, anything)

      player.play
    end

    it "with the correct default attack and decay" do
      player = Stretto::MIDIator::Player.new("C", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)

      player.play
    end

    it "with different attack and decay values" do
      player = Stretto::MIDIator::Player.new("Ca80d30", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 80)
      midi.should_receive(:note_off).with(anything, anything, 30)

      player.play
    end

    context "with a tempo" do

      it "that defaults to Allegro" do
        player = Stretto::MIDIator::Player.new("C", :driver => test_driver)

        player.midi.should_receive(:rest).with(0.5)

        player.play
      end

      it "that is explicitly set" do
        player = Stretto::MIDIator::Player.new("T[Presto] C", :driver => test_driver) # 180 bpm

        player.midi.should_receive(:rest).with(Rational(1, 3))

        player.play
      end

    end

    it "with the default channel of 0" do
      player = Stretto::MIDIator::Player.new("C", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, 0, anything)
      midi.should_receive(:note_off).with(anything, 0, anything)

      player.play
    end

    it "with a specific channel (voice)" do
      player = Stretto::MIDIator::Player.new("V1 C", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, 1, anything)
      midi.should_receive(:note_off).with(anything, 1, anything)

      player.play
    end

   end

  context "plays a chord" do

    it "with the correct pitches" do
      player = Stretto::MIDIator::Player.new("Cmaj", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(36, anything, anything)
      midi.should_receive(:note_on).with(40, anything, anything)
      midi.should_receive(:note_on).with(43, anything, anything)
      midi.should_receive(:note_off).with(36, anything, anything)
      midi.should_receive(:note_off).with(40, anything, anything)
      midi.should_receive(:note_off).with(43, anything, anything)

      player.play
    end

    it "with default attack and decay" do
      player = Stretto::MIDIator::Player.new("Cmaj", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_on).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)
      midi.should_receive(:note_off).with(anything, anything, 64)

      player.play
    end

    it "with a specific attack and decay" do
      player = Stretto::MIDIator::Player.new("Cmaja50d60", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, anything, 50)
      midi.should_receive(:note_on).with(anything, anything, 50)
      midi.should_receive(:note_on).with(anything, anything, 50)
      midi.should_receive(:note_off).with(anything, anything, 60)
      midi.should_receive(:note_off).with(anything, anything, 60)
      midi.should_receive(:note_off).with(anything, anything, 60)

      player.play
    end

    it "with a specific channel (voice)" do
      player = Stretto::MIDIator::Player.new("V2 Cmaj", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).with(anything, 2, anything)
      midi.should_receive(:note_on).with(anything, 2, anything)
      midi.should_receive(:note_on).with(anything, 2, anything)
      midi.should_receive(:note_off).with(anything, 2, anything)
      midi.should_receive(:note_off).with(anything, 2, anything)
      midi.should_receive(:note_off).with(anything, 2, anything)

      player.play
    end

  end

  it "handles measures" do
    player = Stretto::MIDIator::Player.new("C | D", :driver => test_driver)

    lambda { player.play }.should_not raise_error
  end

  it  "handles rests" do
    player = Stretto::MIDIator::Player.new("R", :driver => test_driver)

    midi = player.midi
    midi.should_receive(:note_on).never
    midi.should_receive(:rest).with(0.5)

    player.play
  end

  context "handles ties" do

    it "by playing the tied note once for the correct duration" do
      player = Stretto::MIDIator::Player.new("Ci- C-i", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).once
      midi.should_receive(:rest).with(0.5)

      player.play
    end

    it "across measures" do
      player = Stretto::MIDIator::Player.new("Ci- | C-i", :driver => test_driver)

      player.midi.should_receive(:note_on).once

      player.play
    end

    it "for chords" do
      player = Stretto::MIDIator::Player.new("Cmaji- Cmaj-i", :driver => test_driver)

      midi = player.midi
      midi.should_receive(:note_on).exactly(3).times
      midi.should_receive(:rest).with(0.5)

      player.play
    end

    it "for rests" do
      player = Stretto::MIDIator::Player.new("Ri- | R-i", :driver => test_driver)

      player.midi.should_receive(:rest).with(0.5)

      player.play
    end

  end

end
