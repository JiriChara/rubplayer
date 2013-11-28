module Rubplayer
  class Player < Term
    include Rubplayer::Commands

    attr_reader :mplayer_bin
    attr_accessor :playback, :playlist, :io

    def initialize(opts={}, &block)
      @mplayer_bin ||= %w[/usr/bin/mplayer /usr/local/bin/mplayer].detect do |bin|
        File.exists?(bin) && File.executable?(bin)
      end

      unless @mplayer_bin
        raise "Cannot find Mplayer binary: #{%w[/usr/bin/mplayer /usr/local/bin/mplayer].join(', ')}."
      end

      cmd = "#{@mplayer_bin} -slave -idle"

      @io       = Rubplayer::IO.new(self)
      @playlist = Rubplayer::Playlist.new(self)

      super(Process.pid, cmd, &block)
    end

    def run!
      @io.print("Rubplayer #{Rubplayer::VERSION}", @io.header, 0, 0)
      @io.start_reactor
    ensure
      safely_exit
    end

    def safely_exit(exit_code=0)
      @playback.stop! if @playback.can_stop?
      @io.clear
      @io.print("Thanks for using Rubplayer! Farewell!\n", @io.status_bar, 0, 0)
    ensure
      sleep(1)
      @io.close
      quit(exit_code); destroy
    end

    def play(file_or_url, append=true)
      @playlist.clear unless append
      @playlist << file_or_url
    end

    def enqueue(cmd)
      @queue << "#{cmd}\n"
    end
  end
end
