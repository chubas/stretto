require File.join(File.dirname(__FILE__), 'modifiers/duration')
require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements
    class Rest < MusicElement

      include Duration

      attr_reader :original_duration, :duration

      def initialize(original_string, options = {})
        @original_string = original_string
        build_duration_from_token(options[:original_duration_token])
      end

    end
  end
end