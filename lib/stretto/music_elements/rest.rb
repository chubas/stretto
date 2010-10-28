require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Represents a rest.
    #
    # Is represented by an "R", followed by a duration modifier (see {Duration})
    class Rest < MusicElement

      include Duration

      attr_reader :original_duration

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_rest!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        build_duration_from_token(token[:duration])
      end

      def play(player)
        if !((start_of_tie? && end_of_tie?) || end_of_tie?)
          duration = 60.0 / player.bpm * tied_duration * player.default_beat
          player.midi.rest(duration)
        end
      end
      
    end
  end
end
