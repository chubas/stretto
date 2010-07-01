require File.join(File.dirname(__FILE__), 'layer')

module Stretto

  class Voice < Array

    # Method intended to keep consistency between array-like structures
    def elements
      to_a
    end

  end

end