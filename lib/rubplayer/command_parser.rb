require 'optparse'

module Rubplayer
  class CommandParser
    class << self
      def run(*argv)
        @options = {}

        @opts_parser = OptionParser.new do |opts|
          exec_name = File.basename($PROGRAM_NAME)
          opts.banner = <<-EOS
Lightweight wrapper for MPlayer written in Ruby.
Usage: #{exec_name} [OPTIONS]... [FILE]..."
          EOS
        end

        @opts_parser.parse!(argv)

        player = Rubplayer::Player.new do |p|
          p.playback = Rubplayer::Playback.new(p)
        end

        argv.each do |arg|
          player.play(arg)
        end

        player.run!
      end
    end
  end
end
