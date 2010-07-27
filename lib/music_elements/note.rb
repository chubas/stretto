require File.join(File.dirname(__FILE__), 'music_element')
require File.join(File.dirname(__FILE__), 'modifiers/attack_decay')

module Stretto
  module MusicElements

    # A note is one of the most basic elements in Stretto.
    #
    # It is composed of several elements:
    #
    # +key+:: Represents the note name (from A to G)
    # +accidental+:: The modifier of the note, this is, flats, sharps or the natural indicator
    #              (bb, b, n, #, ##)
    # +pitch+:: The actual numeric pitch of the note, according to MIDI specification (0 to 127)
    # +octave+:: Octave in which the note is located. (0 to 10) The default octave for a note is 5
    #
    # Additionally, it holds a duration (see {Duration}), and attack and decay (see {AttackDecay})
    #
    # Example of valid notes are:
    #
    # +C+:: Returns the note C, with the default octave, duration, attack and decay
    # +[60]+:: The same note, represented by its pitch value
    # +D#7+:: The note D# in the seventh octave
    # +Abwa80d100+:: The note Ab with a whole note duration, an attack of 80 and decay of 100
    #
    # Pitch values and octaves are indicated in the table below:
    #
    #    Octave  |   C |  C# |   D |  D# |   E |   F |  F# |   G |  G# |   A |  A# |   B
    #       0    |   0 |   1 |   2 |   3 |   4 |   5 |   6 |   7 |   8 |   9 |  10 |  11
    #       1    |  12 |  13 |  14 |  15 |  16 |  17 |  18 |  19 |  20 |  21 |  22 |  23
    #       2    |  24 |  25 |  26 |  27 |  28 |  29 |  30 |  31 |  32 |  33 |  34 |  35
    #       3    |  36 |  37 |  38 |  39 |  40 |  41 |  42 |  43 |  44 |  45 |  46 |  47
    #       4    |  48 |  49 |  50 |  51 |  52 |  53 |  54 |  55 |  56 |  57 |  58 |  59
    #       5    |  60 |  61 |  62 |  63 |  64 |  65 |  66 |  67 |  68 |  69 |  70 |  71
    #       6    |  72 |  73 |  74 |  75 |  76 |  77 |  78 |  79 |  80 |  81 |  82 |  83
    #       7    |  84 |  85 |  86 |  87 |  88 |  89 |  90 |  91 |  92 |  93 |  94 |  95
    #       8    |  96 |  97 |  98 |  99 | 100 | 101 | 102 | 103 | 104 | 105 | 106 | 107
    #       9    | 108 | 109 | 110 | 111 | 112 | 113 | 114 | 115 | 116 | 117 | 118 | 119
    #       10   | 120 | 121 | 122 | 123 | 124 | 125 | 126 | 127
    #
    # Where pitch can go from 0 to 127.

    class Note < MusicElement

      include Duration
      include AttackDecay

      # @private
      PITCHES = {
        'C' => 0,
        'D' => 2,
        'E' => 4,
        'F' => 5,
        'G' => 7,
        'A' => 9,
        'B' => 11
      }

      # @private
      ACCIDENTALS = {
        'bb' => -2,
        'b'  => -1,
        '#'  =>  1,
        '##' =>  2
      }

      # @private
      MAX_PITCH      = 127

      # @private
      DEFAULT_OCTAVE = 5

      attr_reader :original_key, :original_accidental, :original_duration, :original_octave
      attr_reader :key_signature
      attr_accessor :instrument

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_note!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_key             = token[:key]
        @original_pitch           = token[:pitch]
        @original_accidental      = token[:accidental]
        @original_octave          = token[:octave]
        build_duration_from_token(token[:duration])
        build_attack_and_decay(token[:attack], token[:decay])
      end

      # Gets pitch of the note.
      # If no original pitch is passed, the pitch gets calculated from the key, accidental
      # and octave values.
      #
      # @return [Number] The pitch of the note, from 0 to 127
      def pitch
        @pitch || build_pitch
      end

      # Gets the octave for the note.
      # If the original string did not contain an oe, the octave for that pitch is returned
      # (see octave table on {MusicElements::Note} documentation.)
      #
      # @return [Number] The octave for the pitch
      def octave
        build_pitch unless @octave
        @octave
      end

      # Gets the key of the note.
      # If the original string did not contain a key note, the key for that pitch is returned
      # (see the pitch table on {MusicElements::Note} documentation.)
      #
      # @return [String] The note key, 'A' through 'G'
      def key
        build_pitch unless @key
        @key
      end

      # Gets the accidental of the note.
      # If the original string did not contain an accidental, the default accidental for the pitch
      # is returned (refer to the pitch table on {MusicElement::Note} documentation), always using
      # sharps for raised notes.
      #
      # @return [String] The accidental of the note
      # @todo Return accidental according to the present key signature
      def accidental
        build_pitch unless @accidental
        @accidental
      end

      # Returns a new note raised by `interval` semitones.
      #
      # @param interval The amount of semitones to raise the pitch.
      # @return [MusicElements::Note] A new note with the raised pitch
      def +(interval)
        new_pitch = if @original_pitch
          @original_pitch + interval
        else
          Stretto::Value.new(Stretto::Value::NumericValue.new(pitch + interval))
        end
        Note.new({
          :text_value => "#{@original_string}+#{interval}",
          :pitch      => new_pitch,
          :duration   => @original_duration_token,
          :attack     => @original_attack,
          :decay      => @original_decay}, @pattern)
      end

      # @return [Boolean] Whether `other` is a note and has the same pitch
      def ==(other)
        # TODO: Revisit the semantics of ==
        other.kind_of?(Note) && other.pitch == pitch
      end

      # @return (see #==)
      def eql?(other)
        # TODO: Revisit the semantics of eql?
        other.kind_of?(Note) && other.pitch.eql?(pitch)
      end

      # @return (see #==)
      def hash
        @pitch.hash
      end

      # Assigns the key signature to this note, altering its pitch.
      #
      # It doesn't affect the note if it has accidental, or its pitch was explicitely
      # given, either with a numeric or variable value
      #
      # @param key_signature [MusicElements::KeySignature]
      def key_signature=(key_signature)
        @key_signature = key_signature
        increment = key_signature_increment
        self.pitch += key_signature_increment if increment
      end

      # Text value of original pitch
      def original_pitch
        @original_pitch.to_s if @original_pitch
      end

      private

        # Builds pitch, and calculates key, octave and accidental with it.
        #-
        # TODO: Refactor into a single method: build_attributes
        def build_pitch
          if @original_pitch
            self.pitch   = @original_pitch.to_i(@pattern)
            @key         = calculate_key_from_pitch(@pitch)
            @octave      = calculate_octave_from_pitch(@pitch)
            @accidental  = calculate_accidental_from_pitch(@pitch)
          else
            @key         = @original_key.upcase
            @octave      = (@original_octave && @original_octave.to_i) || 5
            @accidental  = @original_accidental.downcase if @original_accidental
            self.pitch   = calculate_pitch_from_key_octave_and_accidental(@key, @octave, @accidental)
          end
          @pitch
        end

        # Returns the pitch value calculated from its key, pitch and accidental
        #
        # @return [Number]
        # @example
        #   calculate_pitch_from_key_octave_and_accidental("C", "5", "#") # => 61
        #   calculate_pitch_from_key_octave_and_accidental("G", "4", "b") # => 56
        def calculate_pitch_from_key_octave_and_accidental(key, octave, accidental)
          pitch = 12 * octave
          pitch += PITCHES[key]
          pitch += ACCIDENTALS[accidental] || 0
          pitch
        end

        # @private
        KEYS_FOR_PITCHES = ['C', 'C', 'D', 'D', 'E', 'F', 'F', 'G', 'G', 'A', 'A', 'B']

        # Returns the key for the pitch
        #
        # @return [String]
        # @example
        #   calculate_key_from_pitch(60) # => 'C', for 'C5'
        #   calculate_key_from_pitch(61) # => 'C', for 'C#5'
        def calculate_key_from_pitch(pitch)
          KEYS_FOR_PITCHES[pitch % 12]
        end

        # Returns the octave for pitch
        #
        # @return [Number]
        # @example
        #   calculate_octave_from_pitch(59) # => 4, for "B4"
        #   calculate_octave_from_pitch(60) # => 5, for "C5"
        def calculate_octave_from_pitch(pitch)
          pitch / 12
        end

        # @private
        ACCIDENTALS_FOR_PITCH = [nil, '#', nil, '#', nil, nil, '#', nil, '#', nil, '#', nil]

        # Returns the accidental value for pitch
        #
        # @return [String]
        # @example
        #   calculate_accidental_from_pitch(60) # => nil, pitch for "C"
        #   calculate_accidental_from_pitch(61) # => '#', pitch for "C#"
        def calculate_accidental_from_pitch(value)
          ACCIDENTALS_FOR_PITCH[value % 12]
        end

        # @param pitch [Number] The value for note's pitch
        # @raise [Exceptions::NoteOutOfBoundsException] If the pitch is higher than 127
        def pitch=(pitch)
          raise Exceptions::NoteOutOfBoundsException if pitch < 0 or pitch > MAX_PITCH
          @pitch = pitch
        end

        # @return [Number] The number of semitones the key signature raises
        def key_signature_increment
          if @key_signature and @original_key and !@accidental
            @key_signature.modifier_for(@key)
          else
            nil
          end
        end


        # @private
        # @see MusicElements::MusicElement#substitute_variables!
        def substitute_variables!
          self.attack = attack
          self.decay = decay
          self.pitch = build_pitch
          self.key_signature = @key_signature
        end

    end
    
  end
end