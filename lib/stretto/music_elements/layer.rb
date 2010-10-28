module Stretto

  # Wrapper for a layer: set of elements inside a voice
  #
  # Layers are not part of the MIDI specification, but are
  # a resource to separate multiple notes that should be played
  # together in a voice.
  #
  # This is most useful in the voice 9 (see {Voice}), which is
  # the percussion layer. Different parts of the percussion track
  # can be separated in different layers, and they all play together
  # in the same track.
  class Layer < Array

    # @return [Array(MusicElement)] Its elements as an array
    def elements
      to_a
    end

  end
  
end