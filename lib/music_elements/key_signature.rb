require File.join(File.dirname(__FILE__), 'music_element')

module Stretto
  module MusicElements

    # A key signature indicates the channel to play in the indicated key or scale.
    #
    # This increases or decreases note values for certain notes, according to music theory
    # (see http://en.wikipedia.org/wiki/Key_signature). The key signature is specified by the
    # letter +K+, followed by a key (for example +C+, +D#+ or +Eb+) and the scale (+maj+ or
    # +min+)
    #
    # Note that notes and chords specified with a pitch value will not be affected. That is,
    # given the following pattern "KGmaj F [65]", the first note will raise its pitch to
    # 66 (due to the sharp accidental in the F notes), while the second note will keep its
    # given value of 65
    class KeySignature < MusicElement

      attr_reader :key, :scale

      def initialize(string_or_options, pattern = nil)
        token = case string_or_options
          when String then Stretto::Parser.parse_key_signature!(string_or_options)
          else string_or_options
        end
        super(token[:text_value], pattern)
        @key = normalize_keysig(token[:key])
        @scale = SCALES[token[:scale].downcase]
      end

      # @return [Number] +1, 0 or -1, if the note key has a flat, none or sharp accidental
      #   respectively for the given +note_key+
      def modifier_for(note_key)
        MODIFIERS[@scale][@key][note_key]
      end

      private

        MODIFIERS = {
          :major => {
            'C'   => {},
            'G'   => { 'F' => +1 },
            'D'   => { 'F' => +1, 'C' => +1 },
            'A'   => { 'F' => +1, 'C' => +1, 'G' => +1 },
            'E'   => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1 },
            'B'   => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1, 'A' => +1 },
            'F#'  => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1, 'A' => +1, 'E' => +1},
            'C#'  => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1, 'A' => +1, 'E' => +1, 'B' => +1 },

            'F'   => { 'B' => -1 },
            'Bb'  => { 'B' => -1, 'E' => -1 },
            'Eb'  => { 'B' => -1, 'E' => -1, 'A' => -1 },
            'Ab'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1 },
            'Db'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1, 'G' => -1 },
            'Gb'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1, 'G' => -1, 'C' => -1 },
            'Cb'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1, 'G' => -1, 'C' => -1, 'F' => -1},
          },
          :minor => {
            'A'   => {},
            'E'   => { 'F' => +1 },
            'B'   => { 'F' => +1, 'C' => +1 },
            'F#'  => { 'F' => +1, 'C' => +1, 'G' => +1 },
            'C#'  => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1 },
            'G#'  => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1, 'A' => +1 },
            'D#'  => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1, 'A' => +1, 'E' => +1},
            'A#'  => { 'F' => +1, 'C' => +1, 'G' => +1, 'D' => +1, 'A' => +1, 'E' => +1, 'B' => +1 },
            'D'   => { 'B' => -1 },
            'G'   => { 'B' => -1, 'E' => -1 },
            'C'   => { 'B' => -1, 'E' => -1, 'A' => -1 },
            'F'   => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1 },
            'Bb'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1, 'G' => -1 },
            'Eb'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1, 'G' => -1, 'C' => -1 },
            'Ab'  => { 'B' => -1, 'E' => -1, 'A' => -1, 'D' => -1, 'G' => -1, 'C' => -1, 'F' => -1},
          }
        }

        # ALIASES IN MAJOR SCALE
        MODIFIERS[:major]['Fb'] = MODIFIERS[:major]['E' ]
        MODIFIERS[:major]['Cb'] = MODIFIERS[:major]['B' ]
        MODIFIERS[:major]['Gb'] = MODIFIERS[:major]['F#']
        MODIFIERS[:major]['Db'] = MODIFIERS[:major]['C#']
        MODIFIERS[:major]['B#'] = MODIFIERS[:major]['C' ]

        # EQUIVALENCES FROM MAJOR SCALE TO MINOR SCALE
        MODIFIERS[:major]['G#'] = MODIFIERS[:major]['Ab'] = MODIFIERS[:minor]['F' ]
        MODIFIERS[:major]['D#'] = MODIFIERS[:major]['Eb'] = MODIFIERS[:minor]['C' ]
        MODIFIERS[:major]['A#'] = MODIFIERS[:major]['Bb'] = MODIFIERS[:minor]['G' ]
        MODIFIERS[:major]['E#'] = MODIFIERS[:major]['F' ] = MODIFIERS[:minor]['D' ]

        # ALIASES IN MINOR SCALE
        MODIFIERS[:minor]['B#'] = MODIFIERS[:minor]['C' ]
        MODIFIERS[:minor]['E#'] = MODIFIERS[:minor]['F' ]
        MODIFIERS[:minor]['A#'] = MODIFIERS[:minor]['Bb']
        MODIFIERS[:minor]['D#'] = MODIFIERS[:minor]['Eb']
        MODIFIERS[:minor]['G#'] = MODIFIERS[:minor]['Ab']

        # EQUIVALENCES FROM MINOR SCALE TO MAJOR SCALE
        MODIFIERS[:minor]['Db'] = MODIFIERS[:minor]['C#'] = MODIFIERS[:major]['E' ]
        MODIFIERS[:minor]['Gb'] = MODIFIERS[:minor]['F#'] = MODIFIERS[:major]['A' ]
        MODIFIERS[:minor]['Cb'] = MODIFIERS[:minor]['B' ] = MODIFIERS[:major]['D' ]
        MODIFIERS[:minor]['Fb'] = MODIFIERS[:minor]['E' ] = MODIFIERS[:major]['G' ] 

        SCALES = { 'maj' => :major, 'min' => :minor }

        def normalize_keysig(string)
          string.downcase.sub(/\w/){ |initial| initial.upcase }
        end
    end
  end
end