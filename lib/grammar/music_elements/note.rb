module Stretto
  module MusicElements

    # A note is the most basic element in Stretto.
    # It is composed of several elements:
    # - key:        Represents the note name (from C to A)
    # - accidental: The modifier of the note (#, ##, b, bb or n)
    # - value:      The actual numeric value of the note, according to MIDI specification (0 to 127)
    # - octave:     Octave in which the note is located. (0 to 10)
    # - duration:   Represents the duration of the whole note, not taking into account ties. Can be one
    #               a letter (w, h, q, i, s, t, x, o), a numeric value or a n-tuplet
    # For each attribute presented, the note will hold an original_attribute method, that is the string
    # from which the value was obtained. The accesor for each one of the attributes returns its calculated value
    class Note

      VALUES = { 'C' => 0,
                 'D' => 2,
                 'E' => 4,
                 'F' => 5,
                 'G' => 7,
                 'A' => 9,
                 'B' => 11 }

      ACCIDENTALS = { 'bb' => -2,
                      'b'  => -1,
                      '#'  =>  1,
                      '##' =>  2 }

      DURATIONS = {
                    'w' => 1.0,
                    'h' => 1.0 / 2,
                    'q' => 1.0 / 4,
                    'i' => 1.0 / 8,
                    's' => 1.0 / 16,
                    't' => 1.0 / 32,
                    'x' => 1.0 / 64,
                    'o' => 1.0 / 128 }

      DEFAULT_OCTAVE = 5

      attr_reader :original_string,
                  :original_key, :original_accidental, :original_duration, :original_octave, :original_value,
                  :key, :accidental, :duration, :octave, :value

      def initialize(original_string, options = {})
        @original_string     = original_string
        @original_key        = options[:original_key]
        @original_value      = options[:original_value]
        @original_duration   = options[:original_duration]
        @original_accidental = options[:original_accidental]
        @original_octave     = options[:original_octave]
        build_note_elements
      end

      def +(interval)
        Note.new(nil, :original_value => @value + interval, :original_duration => @original_duration)
      end

      def ==(other)
        other.value == value
      end

      private

      KEYS_FOR_VALUES = ['C', 'C', 'D', 'D', 'E', 'F', 'F', 'G', 'G', 'A', 'A', 'B']
      def build_note_elements
        if @original_value
          self.value   = @original_value.to_i
          @key         = KEYS_FOR_VALUES[@value % 12]
          @octave      = calculate_octave_from_value(@value)
          @accidental  = calculate_accidental_from_value(@value)
        else
          @key         = @original_key
          @octave      = (@original_octave && @original_octave.to_i) || 5
          @accidental  = @original_accidental
          self.value   = calculate_value_from_key_octave_and_accidental(@key, @octave, @accidental)
        end
        @duration = DURATIONS[@original_duration || 'q']
      end

      def calculate_value_from_key_octave_and_accidental(key, octave, accidental)
        value = 12 * octave
        value += VALUES[key]
        value += ACCIDENTALS[accidental] || 0
        value
      end

      def calculate_octave_from_value(value)
        value / 12
      end

      ACCIDENTALS_FOR_VALUE = [nil, '#', nil, '#', nil, nil, '#', nil, '#', nil, '#', nil]
      def calculate_accidental_from_value(value)
        ACCIDENTALS_FOR_VALUE[value % 12]
      end

      def value=(value)
        raise Exceptions::NoteOutOfBoundsException if value > 127
        @value = value
      end

    end
    
  end
end