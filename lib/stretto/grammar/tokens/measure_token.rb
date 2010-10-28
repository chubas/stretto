require File.join(File.dirname(__FILE__), '../../music_elements/measure')

module Stretto
  module Tokens

    # Token result from parsing a measure
    #
    #-
    # Right now, the only supported measure is "|"
    # TODO: Add support for other measures? (Repeat signs, codas, etc.)
   class MeasureToken < HashToken

     # @return [MusicElements::Measure] The constructed Measure element
     def to_stretto(pattern = nil)
       Stretto::MusicElements::Measure.new(self, pattern)
     end

   end

  end
end