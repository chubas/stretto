require File.join(File.dirname(__FILE__), '../../music_elements/measure')

module Stretto
  module Tokens

   class MeasureToken < Treetop::Runtime::SyntaxNode

     def to_stretto
       Stretto::MusicElements::Measure.new(text_value)
     end

   end

  end
end