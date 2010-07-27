require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Timing information places the elements at the specified position in time,
    #
    # This information is mostly used when reading a MIDI file or using it live,
    # to synchronize with playback. The quantity is expressed in miliseconds.
    class Timing < MusicElement

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_timing!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_value = token[:value]
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      # private
        def substitute_variables!
          @value = self.value
        end

    end

  end
end