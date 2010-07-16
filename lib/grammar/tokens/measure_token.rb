require File.join(File.dirname(__FILE__), '../../music_elements/measure')

module Stretto
  module Tokens

   class MeasureToken < HashToken

     def to_stretto(pattern = nil)
       Stretto::MusicElements::Measure.new(self, pattern)
     end

   end

  end
end