require File.join(File.dirname(__FILE__), '../lib/stretto')

ALL_ELEMENTS = {
  :channel_pressure     => '+100',
  :chord                => 'Cmaj3h',
  :controller_change    => 'X[VOLUME]=[OFF]',
  :harmonic_chord       => 'C+D+E',
  :instrument           => 'I[PIANO]',
  :key_signature        => 'KGmaj',
  :layer_change         => 'L0',
  :measure              => '|',
  :melody               => 'Ch+Dh_Ew',
  :note                 => 'C5w',
  :pitch_wheel          => '&100',
  :polyphonic_pressure  => '*60,100',
  :rest                 => 'Rq',
  :tempo                => 'T[ALLEGRO]',
  :timing               => '@2000',
  :variable             => '$MY_VAR=100',
  :voice_change         => 'V0',
}

