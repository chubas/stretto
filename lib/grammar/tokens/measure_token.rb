require File.join(File.dirname(__FILE__), '../../music_elements/measure')

module Stretto
  module Tokens

   class MeasureToken < Treetop::Runtime::SyntaxNode

     def to_stretto(pattern = nil)
       Stretto::MusicElements::Measure.new(
           text_value,
           :pattern => pattern
       )
     end

   end

  end
end