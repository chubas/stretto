module Stretto

  # @see JFugueFormatParser.parse
  module JFugueFormatParser

    def self.parse(jfugue_file)
      begin
        music_string = ""
        until jfugue_file.eof
          line = jfugue_file.readline
          music_string << ' ' + line unless line.blank? or line[0, 1] == "#"
        end
        music_string
      ensure
        jfugue_file.close
      end
    end

  end
end