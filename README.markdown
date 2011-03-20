Stretto
=======

Stretto is Ruby's implementation of [JFugue][1], an open source library originally written in Java by [David Koelle][2] for programming MIDI.

Motivation
----------

JFugue's syntax is great for producing both a human readable and parseable implementation of the MIDI specification. By detaching it from the Java sound engine, it can become an specification and be implemented in several languages/platforms. This implementation aims to be compatible with JFugue as well as serve as the basis for the format specification.

Installation
------------

    gem install stretto


MIDI Playback
-------------

    require 'rubygems'
    require 'stretto'

    # play a scale
    player = Stretto::Player.new
    player.play("C D E F G A B")

    # play a .jfugue file
    file = File.new(File.dirname(__FILE__) + '/examples/entertainer.jfugue')
    player.play(file)

Stretto currently supports the following subset of JFugue's syntax For MIDI playback:

- notes
- rests
- measures
- chords
- harmonies
- multiple voices
- melodies
- variables
- tempo changes
- channel pressure
- polyphonic pressure
- instruments
- pitch bends
- controller changes

For more on syntax, check out [The Complete Guide to JFugue][3]. The
second chapter is free, and covers a good chunk of what is possible with JFugue.

Stretto uses [midiator][4] for MIDI playback. If you're running OS X,
the built-in softsynth driver should just work. You can also try creating a Player with another driver, such as core_audio or alsa:

    player = Stretto::Player.new(:driver => :alsa)

Contributing
------------

Stretto uses Bundler for dependency management. To run the test suite:

    bundle install
    rake

  [1]: http://www.jfugue.org/
  [2]: http://blog.davekoelle.com/
  [3]: http://www.jfugue.org/book.html
  [4]: https://github.com/bleything/midiator
