module Rubplayer
  class Player < Term
    include Rubplayer::Commands

    attr_reader :mplayer_bin, :io

    def initialize(opts={}, &block)
      @mplayer_bin ||= %w[/usr/bin/mplayer /usr/local/bin/mplayer].detect do |bin|
        File.exists?(bin) && File.executable?(bin)
      end

      unless @mplayer_bin
        raise "Cannot find Mplayer binary: #{%w[/usr/bin/mplayer /usr/local/bin/mplayer].join(', ')}."
      end

      cmd = "#{@mplayer_bin} -slave -idle"

      @io = Rubplayer::IO.new(self)

      @io.print("Rubplyer v.#{::Rubplayer::VERSION}\n")

      super(Process.pid, cmd, &block)

      @io.start_reactor
    ensure
      safely_exit
    end

    def safely_exit(exit_code=0)
      @io.print("Thanks for using Rubplayer! Farewell!\n")
    ensure
      sleep(1)
      @io.close
      quit(exit_code); destroy
    end

    def enqueue(cmd)
      @queue << "#{cmd}\n"
    end
  end
end
