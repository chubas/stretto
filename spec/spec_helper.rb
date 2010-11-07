require 'rubygems'
require 'yaml'
require 'spec'

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
  :note                 => 'C5w',
  :pitch_wheel          => '&100',
  :polyphonic_pressure  => '*60,100',
  :rest                 => 'Rq',
  :tempo                => 'T[ALLEGRO]',
  :timing               => '@2000',
  :variable             => '$MY_VAR=100',
  :voice_change         => 'V0',
} unless defined?(ALL_ELEMENTS)

spec_options_path = File.dirname(__FILE__) + '/spec_options.yml'
begin
  SPEC_OPTIONS = YAML::load(File.read(spec_options_path)) unless defined?(SPEC_OPTIONS)
rescue
  raise "You need to place a valid configuration file at 'spec/spec_options.yml'"
end

def test_driver
  @driver ||= SPEC_OPTIONS['test_midi_driver'].to_sym
end


