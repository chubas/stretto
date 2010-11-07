require File.dirname(__FILE__) + '/../spec_helper'

describe "controller changes" do

  it "should parse elements as controller changes" do
    pattern = Stretto::Pattern.new("$VOLUME=100 X[VOLUME]=1024 C D E X32=800 F G A")
    pattern[1].should be_an_instance_of(Stretto::MusicElements::ControllerChange)
    pattern[5].should be_an_instance_of(Stretto::MusicElements::ControllerChange)
  end

  it "should correctly set the controller field" do
    Stretto::Pattern.new("X100=200")[0].controller.should be == 100
  end

  it "should correctly set the value field" do
    Stretto::Pattern.new("X100=200")[0].value.should be == 200
  end

  it "should allow setting of coarse and fine values" # Not a priority for the moment

  it "should allow notes in variable notation" do
    pattern = Stretto::Pattern.new(
        "$MY_CONTROLLER=80 $MY_VALUE=100 X[MY_CONTROLLER]=60 X60=[MY_VALUE] X[MY_CONTROLLER]=[MY_VALUE]"
    )
    pattern[2].controller.should be == 80
    pattern[2].value.should be == 60
    pattern[3].controller.should be == 60
    pattern[3].value.should be == 100
    pattern[4].controller.should be == 80
    pattern[4].value.should be == 100

  end

  context "using the predefined JFugue variables" do
    it "should use the predefined controller change variables (1)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [0, 1, 2, 4, 5, 6, 7, 8, 10, 11, 12, 13]
        X[BANK_SELECT_COARSE]=0 X[MOD_WHEEL_COARSE]=0 X[BREATH_COARSE]=0 X[FOOT_PEDAL_COARSE]=0
        X[PORTAMENTO_TIME_COARSE]=0 X[DATA_ENTRY_COARSE]=0 X[VOLUME_COARSE]=0 X[BALANCE_COARSE]=0
        X[PAN_POSITION_COARSE]=0 X[EXPRESSION_COARSE]=0 X[EFFECT_CONTROL_1_COARSE]=0 X[EFFECT_CONTROL_2_COARSE]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (2)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [16, 17, 18, 19]
        X[SLIDER_1]=0 X[SLIDER_2]=0 X[SLIDER_3]=0 X[SLIDER_4]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (3)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [32, 33, 34, 36, 37, 38, 39, 40, 42, 43, 44, 45]
        X[BANK_SELECT_FINE]=0 X[MOD_WHEEL_FINE]=0 X[BREATH_FINE]=0 X[FOOT_PEDAL_FINE]=0
        X[PORTAMENTO_TIME_FINE]=0 X[DATA_ENTRY_FINE]=0 X[VOLUME_FINE]=0 X[BALANCE_FINE]=0
        X[PAN_POSITION_FINE]=0 X[EXPRESSION_FINE]=0 X[EFFECT_CONTROL_1_FINE]=0 X[EFFECT_CONTROL_2_FINE]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (4)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [64, 64, 65, 66, 66, 67, 67, 68, 68, 69, 69]
        X[HOLD_PEDAL]=0 X[HOLD]=0 X[PORTAMENTO]=0 X[SUSTENUTO_PEDAL]=0 X[SUSTENUTO]=0 X[SOFT_PEDAL]=0
        X[SOFT]=0 X[LEGATO_PEDAL]=0 X[LEGATO]=0 X[HOLD_2_PEDAL]=0 X[HOLD_2]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (5)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [70, 70, 71, 71, 72, 72, 73, 73, 74, 74, 75, 75, 76, 76, 77, 77, 78, 78, 79, 79]
        X[SOUND_VARIATION]=0 X[VARIATION]=0 X[SOUND_TIMBRE]=0 X[TIMBRE]=0 X[SOUND_RELEASE_TIME]=0 X[RELEASE_TIME]=0
        X[SOUND_ATTACK_TIME]=0 X[ATTACK_TIME]=0 X[SOUND_BRIGHTNESS]=0 X[X_BRIGHTNESS]=0 X[SOUND_CONTROL_6]=0
        X[CONTROL_6]=0 X[SOUND_CONTROL_7]=0 X[CONTROL_7]=0 X[SOUND_CONTROL_8]=0 X[CONTROL_8]=0
        X[SOUND_CONTROL_9]=0 X[CONTROL_9]=0 X[SOUND_CONTROL_10]=0 X[CONTROL_10]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (6)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [80, 80, 80, 81, 81, 81, 82, 82, 82, 83, 83, 83]
        X[GENERAL_PURPOSE_BUTTON_1]=0 X[GENERAL_BUTTON_1]=0 X[BUTTON_1]=0
        X[GENERAL_PURPOSE_BUTTON_2]=0 X[GENERAL_BUTTON_2]=0 X[BUTTON_2]=0
        X[GENERAL_PURPOSE_BUTTON_3]=0 X[GENERAL_BUTTON_3]=0 X[BUTTON_3]=0
        X[GENERAL_PURPOSE_BUTTON_4]=0 X[GENERAL_BUTTON_4]=0 X[BUTTON_4]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (7)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [91, 91, 92, 92, 93, 93, 94, 94, 95, 95]
        X[EFFECTS_LEVEL]=0 X[EFFECTS]=0 X[TREMOLO_LEVEL]=0 X[TREMOLO]=0 X[CHORUS_LEVEL]=0 X[CHORUS]=0
        X[CELESTE_LEVEL]=0 X[CELESTE]=0 X[PHASER_LEVEL]=0 X[PHASER]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (8)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [96, 96, 96, 97, 97, 97]
        X[DATA_BUTTON_INCREMENT]=0 X[DATA_BUTTON_INC]=0 X[BUTTON_INC]=0
        X[DATA_BUTTON_DECREMENT]=0 X[DATA_BUTTON_DEC]=0 X[BUTTON_DEC]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (9)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [98, 99, 100, 101]
        X[NON_REGISTERED_COARSE]=0 X[NON_REGISTERED_FINE]=0 X[REGISTERED_COARSE]=0 X[REGISTERED_FINE]=0
      CONTROLLERS
    end

    it "should use the predefined controller change variables (10)" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [120, 121, 122, 123, 124, 124, 125, 125, 126, 126, 127, 127]
        X[ALL_SOUND_OFF]=0 X[ALL_CONTROLLERS_OFF]=0 X[LOCAL_KEYBOARD]=0 X[ALL_NOTES_OFF]=0
        X[OMNI_MODE_OFF]=0 X[OMNI_OFF]=0 X[OMNI_MODE_ON]=0 X[OMNI_ON]=0
        X[MONO_OPERATION]=0 X[MONO]=0 X[POLY_OPERATION]=0 X[POLY]=0
      CONTROLLERS
    end

    it "should use the predefined combined controller change variables" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:controller).should be == [16383, 161, 290, 548, 677, 806, 935, 1064, 1322, 1451, 1580, 1709, 12770, 13208]
        X[BANK_SELECT]=0 X[MOD_WHEEL]=0 X[BREATH]=0 X[FOOT_PEDAL]=0 X[PORTAMENTO_TIME]=0 X[DATA_ENTRY]=0
        X[VOLUME]=0 X[BALANCE]=0 X[PAN_POSITION]=0 X[EXPRESSION]=0 X[EFFECT_CONTROL_1]=0 X[EFFECT_CONTROL_2]=0
        X[NON_REGISTERED]=0 X[REGISTERED]=0
      CONTROLLERS
    end

    it "should use the predefined controller change value variables" do
      Stretto::Pattern.new(<<-CONTROLLERS).map(&:value).should be == [127, 0, 64]
        X[VOLUME]=[ON] X[VOLUME]=[OFF] X[VOLUME]=[DEFAULT]
      CONTROLLERS
    end
  end

end