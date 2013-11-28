module Rubplayer
  module Commands
    # Load the given file/URL, stopping playback of the current file/URL.
    # If <append> is nonzero playback continues and the file/URL is
    # appended to the current playlist instead.
    def loadfile(file, append=false)
      append = append ? 1 : 0
      enqueue("loadfile \"#{file}\" #{append}")
    end

    # Load the given playlist file, stopping playback of the current file.
    # If <append> is nonzero playback continues and the playlist file is
    # appended to the current playlist instead.
    def loadlist(file, append=false)
      append = append ? 1 : 0
      enqueue("loadlist \"#{file}\" #{append}")
    end

    # Pause/unpause the playback.
    def pause
      enqueue("pause")
    end

    # Stop playback.
    def stop
      enqueue("stop")
    end

    # Toggle sound output muting or set it to [value] when [value] >= 0
    # (1 == on, 0 == off).
    def mute(value=false)
      enqueue("mute #{value ? 1 : 0}")
    end

    # Take a screenshot. Requires the screenshot filter to be loaded.
    #   0 Take a single screenshot.
    #   1 Start/stop taking screenshot of each frame.
    def screenshot(value = false)
      enqueue("screenshot #{value ? 1 : 0}")
    end

    # Seek to some place in the movie.
    #   0 is a relative seek of +/- <value> seconds (default).
    #   1 is a seek to <value> % in the movie.
    #   2 is a seek to an absolute position of <value> seconds.
    def seek(value, type=0)
      enqueue("seek #{value} #{type}")
    end

    # Quit MPlayer. The optional integer [value] is used as the return code
    # for the mplayer process (default: 0).
    def quit(value=0)
      enqueue("quit #{value}")
    end

    # Increase/decrease volume or set it to <value> if [abs] is nonzero.
    def volume(value, abs=true)
      abs = abs ? 1 : 0
      enqueue("volume #{value} #{abs}")
    end
  end
end
