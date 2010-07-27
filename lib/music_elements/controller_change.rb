require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # Represents a MIDI controller event.
    #
    # MIDI specification defines about 100 controller events, that are used by the
    # instruments or synthesizer to perform a range of effects and control settings.
    #
    # JFugue defines the most common ones (See {Variables::CONTROLLER_VARIABLES}),
    # and provides a shortcut for mixed (coarse and fine values) controllers.
    #
    # The syntax for a controller change is X_controller_=_value_, where controller is the
    # number of the controller event, and value is the value that is going to be set.
    class ControllerChange < MusicElement

      attr_reader :controller, :value

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_controller_change!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @original_controller = token[:controller]
        @original_value      = token[:value]
      end

      def controller
        @controller || @original_controller.to_i(@pattern)
      end

      def value
        @value || @original_value.to_i(@pattern)
      end

      private

        # @private
        def substitute_variables!
          @controller = @original_controller.to_i(@pattern)
          @value      = @original_value.to_i(@pattern)
        end

    end

  end
end