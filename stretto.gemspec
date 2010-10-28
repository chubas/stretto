# -*- coding: utf-8 -*-
$: << File.dirname(__FILE__) + "/lib"
require 'stretto/version'

Gem::Specification.new do |s|
  s.name = "stretto"
  s.version = Stretto::VERSION
  s.authors = ["Rubén Medellín"]
  s.summary = "A Ruby implementation of JFugue"
  s.description = "Stretto is a Ruby implementation of JFugue, " +
    "an open source library originally written in Java by David Koelle for " +
    "programming MIDI."
  s.homepage    = "http://github.com/chubas/stretto"
  
  s.add_development_dependency "rspec"

  s.add_dependency "treetop", ">= 1.4.8" 
  s.add_dependency "polyglot", ">= 0.3.1" 
  s.add_dependency "midiator", ">= 0.3.2" 

  s.files = Dir.glob("lib/**/*") + %w(Rakefile README.markdown CHANGELOG.markdown)
  s.require_path = "lib"
end
