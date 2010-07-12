require File.dirname(__FILE__) + '/../spec_helper'

describe "instruments" do

  it "should parse instrument as a music element" do
    Stretto::Pattern.new("I100").first.should be_an_instance_of(Stretto::MusicElements::Instrument)
  end

  it "should assign an instrument to the music element being played" do
    note = Stretto::Pattern.new("I100 C5")[1]
    note.instrument.should_not be_nil
    note.instrument.value.should be == 100
  end

  it "should use the default intrument of 0 if not present" do
    Stretto::Pattern.new("C5").first.instrument.value.should be == 0
  end

  context "when using literal (numeric) value" do
    it "should return the correct value" do
      Stretto::Pattern.new("I100").first.value.should be == 100
    end

    it "should not allow a value higher than 127" do
      lambda { Stretto::Pattern.new("I127") }.should_not raise_error
      lambda { Stretto::Pattern.new("I128") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /instrument/i)
    end
  end

  context "when using variable value" do
    it "should return the correct value" do
      Stretto::Pattern.new("$MY_VAR=20 I[MY_VAR]")[1].value.should be == 20
    end

    it "should not allow a value higher than 127" do
      lambda{ Stretto::Pattern.new("$MY_VALUE=128 I[MY_VALUE]") }.should raise_error(Stretto::Exceptions::ValueOutOfBoundsException, /instrument/i)
    end

    context "when using the predefined variables for instruments according to the original JFugue implementation" do
      it "should accept the Piano section instrument variables" do
        Stretto::Pattern.new(<<-PIANOS).map(&:value).should be == [0, 0, 1, 2, 3, 4, 4, 5, 6, 7]
          I[PIANO] I[ACOUSTIC_GRAND] I[BRIGHT_ACOUSTIC] I[ELECTRIC_GRAND] I[HONKEY_TONK]
          I[ELECTRIC_PIANO] I[ELECTRIC_PIANO_1] I[ELECTRIC_PIANO_2] I[HARPISCHORD] I[CLAVINET]
        PIANOS
      end

      it "should accept the Chromatic percussion section instrument variables" do
        Stretto::Pattern.new(<<-CHROMATIC).map(&:value).should be == [*8..15]
          I[CELESTA] I[GLOCKENSPIEL] I[MUSIC_BOX] I[VIBRAPHONE] I[MARIMBA] I[XYLOPHONE] I[TUBULAR_BELLS] I[DULCIMER]
        CHROMATIC
      end
      
      it "should accept the Organ section instrument variables" do
        Stretto::Pattern.new(<<-ORGANS).map(&:value).should be == [*16..23]
          I[DRAWBAR_ORGAN] I[PERCUSSIVE_ORGAN] I[ROCK_ORGAN] I[CHURCH_ORGAN]
          I[REED_ORGAN] I[ACCORDION] I[HARMONICA] I[TANGO_ACCORDION]
        ORGANS
      end

      it "should accept the Guitar section instrument variables" do
        Stretto::Pattern.new(<<-GUITARS).map(&:value).should be == [24, 24, 25, 26, 27, 28, 29, 30, 31]
          I[GUITAR] I[NYLON_STRING_GUITAR] I[STEEL_STRING_GUITAR] I[ELECTRIC_JAZZ_GUITAR] I[ELECTRIC_CLEAN_GUITAR]
          I[ELECTRIC_MUTED_GUITAR] I[OVERDRIVEN_GUITAR] I[DISTORTION_GUITAR] I[GUITAR_HARMONICS]
        GUITARS
      end

      it "should accept the Bass section instrument variables" do
        Stretto::Pattern.new(<<-BASSES).map(&:value).should be == [*32..39]
          I[ACOUSTIC_BASS] I[ELECTRIC_BASS_FINGER] I[ELECTRIC_BASS_PICK] I[FRETLESS_BASS]
          I[SLAP_BASS_1] I[SLAP_BASS_2] I[SYNTH_BASS_1] I[SYNTH_BASS_2]
        BASSES
      end

      it "should accept the Strings section instrument variables" do
        Stretto::Pattern.new(<<-STRINGS).map(&:value).should be == [*40..47]
          I[VIOLIN] I[VIOLA] I[CELLO] I[CONTRABASS] I[TREMOLO_STRINGS]
          I[PIZZICATO_STRINGS] I[ORCHESTRAL_STRINGS] I[TIMPANI]
        STRINGS
      end

      it "should accept the Ensemble section instrument variables" do
        Stretto::Pattern.new(<<-ENSEMBLE).map(&:value).should be == [*48..55]
          I[STRING_ENSEMBLE_1] I[STRING_ENSEMBLE_2] I[SYNTH_STRINGS_1] I[SYNTH_STRINGS_2]
          I[CHOIR_AAHS] I[VOICE_OOHS] I[SYNTH_VOICE] I[ORCHESTRA_HIT]
        ENSEMBLE
      end

      it "should accept the Brass section instrument variables" do
        Stretto::Pattern.new(<<-BRASS).map(&:value).should be == [*56..63]
          I[TRUMPET] I[TROMBONE] I[TUBA] I[MUTED_TRUMPET] I[FRENCH_HORN] I[BRASS_SECTION] I[SYNTHBRASS_1] I[SYNTHBRASS_2]
        BRASS
      end

      it "should accept the Reeds section instrument variables" do
        Stretto::Pattern.new(<<-REEDS).map(&:value).should be == [*64..71]
          I[SOPRANO_SAX] I[ALTO_SAX] I[TENOR_SAX] I[BARITONE_SAX] I[OBOE] I[ENGLISH_HORN] I[BASOON] I[CLARINET]
        REEDS
      end

      it "should accept the Pipes section instrument variables" do
        Stretto::Pattern.new(<<-PIPES).map(&:value).should be == [*72..79]
          I[PICCOLO] I[FLUTE] I[RECORDER] I[PAN_FLUTE] I[BLOWN_BOTTLE] I[SHAKUHACHI] I[WHISTLE] I[OCARINA]
        PIPES
      end

      it "should accept the Synth leads section instrument variables" do
        Stretto::Pattern.new(<<-LEADS).map(&:value).should be == (values = [*80..87]).zip(values).flatten
          I[LEAD_SQUARE] I[SQUARE] I[LEAD_SAWTOOTH] I[SAWTOOTH] I[LEAD_CALLIOPE] I[CALLIOPE]
          I[LEAD_CHIFF] I[CHIFF] I[LEAD_CHARANG] I[CHARANG] I[LEAD_VOICE] I[VOICE]
          I[LEAD_FIFTHS] I[FIFTHS] I[LEAD_BASSLEAD] I[BASSLEAD]
        LEADS
      end
      
      it "should accept the Synth pads section instrument variables" do
        Stretto::Pattern.new(<<-PADS).map(&:value).should be == (values = [*88..95]).zip(values).flatten
          I[PAD_NEW_AGE] I[NEW_AGE] I[PAD_WARM] I[WARM] I[PAD_POLYSYNTH] I[POLYSYNTH] I[PAD_CHOIR] I[CHOIR]
          I[PAD_BOWED] I[BOWED] I[PAD_METALLIC] I[METALLIC] I[PAD_HALO] I[HALO] I[PAD_SWEEP] I[SWEEP]
        PADS
      end

      it "should accept the Synth effects section instrument variables" do
        Stretto::Pattern.new(<<-FX).map(&:value).should be == (values = [*96..103]).zip(values).flatten
          I[FX_RAIN] I[RAIN] I[FX_SOUNDTRACK] I[SOUNDTRACK] I[FX_CRYSTAL] I[CRYSTAL] I[FX_ATMOSPHERE] I[ATMOSPHERE]
          I[FX_BRIGHTNESS] I[BRIGHTNESS] I[FX_GOBLINS] I[GOBLINS] I[FX_ECHOES] I[ECHOES] I[FX_SCI_FI] I[SCI_FI]
        FX
      end

      it "should accept the Ethnic section instrument variables" do
        Stretto::Pattern.new(<<-ETHNIC).map(&:value).should be == [*104..111]
          I[SITAR] I[BANJO] I[SHAMISEN] I[KOTO] I[KALIMBA] I[BAGPIPE] I[FIDDLE] I[SHANAI]
        ETHNIC
      end
      
      it "should accept the Percussive section instrument variables" do
        Stretto::Pattern.new(<<-PERCUSSIVE).map(&:value).should be == [*112..119]
          I[TINKLE_BELL] I[AGOGO] I[STEEL_DRUMS] I[WOODBLOCK] I[TAIKO_DRUM] I[MELODIC_TOM] I[SYNTH_DRUM] I[REVERSE_CYMBAL]
        PERCUSSIVE
      end

      it "should accept the Sound effects section instrument variables" do
        Stretto::Pattern.new(<<-SOUND_EFFECTS).map(&:value).should be == [*120..127]
          I[GUITAR_FRET_NOISE] I[BREATH_NOISE] I[SEASHORE] I[BIRD_TWEET]
          I[TELEPHONE_RING] I[HELICOPTER] I[APPLAUSE] I[GUNSHOT]
        SOUND_EFFECTS
      end
    end
  end

  context "when using multiple voices in a composition" do
    it "should not affect the instrument of other voices" do
      pattern = Stretto::Pattern.new("V0 I80 C V1 D")
      pattern[2].instrument.value.should be == 80
      pattern[4].instrument.value.should be == 0
    end

    it "should change the instrument per voice effectively" do
      pattern = Stretto::Pattern.new("V0 I50 C V1 Dmaj V0 I60 E V1 I80 Fmaj")
      pattern[2].instrument.value.should be == 50
      pattern[4].instrument.value.should be == 0
      pattern[7].instrument.value.should be == 60
      pattern[10].instrument.value.should be == 80
    end

    it "should use the same instrument per voice even if in different layers?"
    # TODO: What happens for example in "V0 L0 I80 C I100 D" ?

  end

end