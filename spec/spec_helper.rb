require File.join(File.dirname(__FILE__), '../lib/stretto')

ALL_ELEMENTS = {
  :note => 'C5w',
  :chord => 'Cmaj3h',
  :rest => 'Rq',
  :measure => '|',
  :harmonic_chord => 'C+D+E',
  :melody => 'Ch+Dh_Ew',
  :key_signature => 'KGmaj',
  :controller_change => 'X[VOLUME]=[OFF]',
  :instrument => 'I[PIANO]',
  :layer_change => 'L0',
  :voice_change => 'V0',
  :pitch_wheel => '&100',
  :polyphonic_pressure => '*60,100',
  :channel_pressute => '+100',
  :variable => '$MY_VAR=100',
  :timing => '@2000'
}

