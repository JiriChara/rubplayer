module Rubplayer
  class Playlist
    def initialize(player)
      @player = player
      @list   = []
    end

    def <<(file_or_url)
      @list << file_or_url

      if @player.playback.can_play?
        @player.playback.play!(file_or_url)
      end
    end

    def method_missing(sym, *args, &block)
      @list.send(sym, *args, &block)
    end
  end
end
