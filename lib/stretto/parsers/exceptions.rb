module Stretto
  module Exceptions
    class InvalidValueException       < StandardError; end
    class ValueOutOfBoundsException   < StandardError; end
    class NoteOutOfBoundsException    < StandardError; end
    class ChordInversionsException    < StandardError; end
    class VariableNotDefinedException < StandardError; end
    class VariableContextException    < StandardError; end
    class ParseError                  < StandardError; end
  end
end
