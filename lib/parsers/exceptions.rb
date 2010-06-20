module Stretto
  module Exceptions
    class InvalidValueException     < StandardError; end
    class NoteOutOfBoundsException  < StandardError; end
    class ChordInversionsException  < StandardError; end
    class InvalidTieException       < StandardError; end
  end
end
