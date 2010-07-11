require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # A note is the most basic element in Stretto.
    # It is composed of several elements:
    # - key:        Represents the note name (from C to A)
    # - accidental: The modifier of the note (#, ##, b, bb or n)
    # - pitch:      The actual numeric pitch of the note, according to MIDI specification (0 to 127)
    # - octave:     Octave in which the note is located. (0 to 10)
    # - duration:   Represents the duration of the whole note, not taking into account ties. Can be one
    #               a letter (w, h, q, i, s, t, x, o), a numeric value or a n-tuplet
    # For each attribute presented, the note will hold an original_attribute method, that is the string
    # from which the value was obtained. The accesor for each one of the attributes returns its calculated value
    class Note < MusicElement

      include Duration

      PITCHES = { 'C' => 0,
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

      MAX_PITCH      = 127

      DEFAULT_OCTAVE = 5

      DEFAULT_ATTACK = 0
      DEFAULT_DECAY  = 0

      attr_reader :original_key, :original_accidental, :original_duration, :original_octave,
                  :key, :accidental, :octave

      attr_reader :original_attack, :original_decay

      attr_reader :key_signature

      def initialize(original_string, options = {})
        super(original_string, options)
        @original_key             = options[:original_key]
        @original_pitch           = options[:original_pitch]
        @original_accidental      = options[:original_accidental]
        @original_octave          = options[:original_octave]
        build_duration_from_token(options[:original_duration_token])
        build_attack(options[:original_attack])
        build_decay(options[:original_decay])
      end

      def +(interval)
        if @original_pitch.has_value?
          Note.new "#{@original_string}+#{interval}",
                   :original_pitch          => @original_pitch + interval,
                   :original_duration_token => @original_duration_token,
                   :original_attack         => @original_attack,
                   :original_decay          => @original_decay
        else
          new_pitch = calculate_pitch_from_key_octave_and_accidental(@key, @octave, @accidental) + interval + (key_signature_increment || 0)
          new_pitch_token = Stretto::Value.new(Stretto::Value::NumericValue.new(new_pitch))
          Note.new "#{@original_string}+#{interval}",
                   :original_pitch          => new_pitch_token,
                   :original_duration_token => @original_duration_token,
                   :original_attack         => @original_attack,
                   :original_decay          => @original_decay
        end
      end

      # TODO: Revisit the semantics of ==
      def ==(other)
        other.pitch == @pitch rescue false
      end

      # TODO: Revisit the semantics of eql?
      def eql?(other)
        other.pitch.eql?(@pitch) rescue false
      end

      def hash
        @pitch.hash
      end

      def key_signature=(key_signature)
        @key_signature = key_signature
        increment = key_signature_increment
        self.pitch += key_signature_increment if increment
      end

      def key_signature_increment
        if @key_signature and !@accidental
          @key_signature.modifier_for(@original_key)
        else
          nil
        end
      end

      def attack
        @original_attack.to_i(@pattern) || DEFAULT_ATTACK
      end

      def decay
        @original_decay.to_i(@pattern) || DEFAULT_DECAY
      end

      def original_pitch
        @original_pitch.to_s if @original_pitch.has_value?
      end

      # TODO: Raise value if it cannot be calculated beforehand (Original pitch should never be nil)
      def pitch
        @pitch
      end

      private

      KEYS_FOR_PITCHES = ['C', 'C', 'D', 'D', 'E', 'F', 'F', 'G', 'G', 'A', 'A', 'B']

      def build_pitch
        if @original_pitch.has_value?
          self.pitch   = @original_pitch.to_i(@pattern)
          @key         = KEYS_FOR_PITCHES[@pitch % 12]
          @octave      = calculate_octave_from_pitch(@pitch)
          @accidental  = calculate_accidental_from_pitch(@pitch)
        else
          @key         = @original_key
          @octave      = (@original_octave && @original_octave.to_i) || 5
          @accidental  = @original_accidental
          self.pitch   = calculate_pitch_from_key_octave_and_accidental(@key, @octave, @accidental)
        end
      end

      def calculate_pitch_from_key_octave_and_accidental(key, octave, accidental)
        pitch = 12 * octave
        pitch += PITCHES[key]
        pitch += ACCIDENTALS[accidental] || 0
        pitch
      end

      def calculate_octave_from_pitch(pitch)
        pitch / 12
      end

      ACCIDENTALS_FOR_PITCH = [nil, '#', nil, '#', nil, nil, '#', nil, '#', nil, '#', nil]
      def calculate_accidental_from_pitch(value)
        ACCIDENTALS_FOR_PITCH[value % 12]
      end

      # Sets the decimal value (pitch) of the note, but raises an error if it's out of range (0...127)
      # TODO: Raise error if nil
      def pitch=(pitch)
        raise Exceptions::NoteOutOfBoundsException if pitch < 0 or pitch > MAX_PITCH
        @pitch = pitch
      end

      def build_attack(original_attack)
        @original_attack = original_attack
      end

      def attack=(attack)
        @attack = attack || DEFAULT_ATTACK
        raise Exceptions::InvalidValueException.new("Attack should be in the range 0..127") if @attack < 0 or @attack > 127
      end

      def build_decay(original_decay)
        @original_decay = original_decay
      end

      def decay=(decay)
        @decay = decay || DEFAULT_DECAY
        raise Exceptions::InvalidValueException.new("Decay should be in the range 0..127") if @decay < 0 or @decay > 127
      end

      def substitute_variables!
        self.attack = attack
        self.decay = decay
        build_pitch
        self.key_signature = @key_signature
      end

    end
    
  end
end