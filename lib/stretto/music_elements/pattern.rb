require File.join(File.dirname(__FILE__), 'voice')
require File.join(File.dirname(__FILE__), '../util/jfugue_format_parser')

module Stretto

  # Pattern is a series of MusicElements, that hold a context (like tied notes or key signature modifications)
  # Is the equivalent of the JFugue implementation +Pattern+
  #-
  # NOTE: This class behavior is not definite, and may change during the development of Stretto
  # until the first stable version
  #+
  class Pattern < Array

    include Variables

    DEFAULT_VOICE_INDEX = 0

    attr_reader :voices, :variables # TODO: Limit access to variables

    # Initializes a pattern
    # @param music_string_or_file [String, File] Can be the music string directly, or
    #   a file in jfugue format.
    def initialize(music_string_or_file = "")
      @music_string = get_music_string_from(music_string_or_file)
      @parser           = Stretto::Parser.new(@music_string)
      @voices           = { }
      @variables        = { }
      @__key_signature  = { }
      @__instruments    = { }
      if @parser.valid?
        @parser.to_stretto(self).each { |music_element| self << music_element }
      else
        raise "Invalid music string \"#{@music_string}\" at character #{@parser.error_on}"
      end
    end

    def elements
      to_a
    end

    def to_s
      @music_string
    end

    def <<(other)
      other.pattern = self

      if other.kind_of?(MusicElements::Variable)
        @variables[other.name.upcase] = other.value
      end

      if other.kind_of?(MusicElements::VoiceChange)
        @current_voice = (@voices[other.index] ||= Voice.new(other.index))
      else
        @voices[DEFAULT_VOICE_INDEX] = @current_voice = Voice.new(DEFAULT_VOICE_INDEX) unless @current_voice
        @current_voice << other
        if @current_voice.size > 1
          @current_voice[-2].next = @current_voice[-1]
          @current_voice[-1].prev = @current_voice[-2]
        end
      end

      if other.kind_of?(MusicElements::KeySignature)
        @__key_signature[@current_voice.index] = other
      else
        other.key_signature = @__key_signature[@current_voice.index] if other.respond_to?(:key_signature=)
      end

      if other.kind_of?(MusicElements::Instrument)
        @__instruments[@current_voice.index] = other
      else
        @__instruments[@current_voice.index] ||= MusicElements::Instrument.default_instrument(self)
        other.instrument = @__instruments[@current_voice.index] if other.respond_to?(:instrument=)
      end

      super(other)
    end

    def voice(index)
      @voices[index]
    end

    def variable(name)
      @variables[name.upcase] ||
          (Value.new(Value::NumericValue.new(PREDEFINED_VARIABLES[name.upcase])) if PREDEFINED_VARIABLES[name.upcase]) ||
          raise(Exceptions::VariableNotDefinedException.new("Variable '#{name}' not defined in pattern"))
    end

    private
      def get_music_string_from(music_string_or_file)
        case music_string_or_file
          when String
            music_string_or_file
          when File
            Stretto::JFugueFormatParser.parse(music_string_or_file)
        end
      end

  end
end
