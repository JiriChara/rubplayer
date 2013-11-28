module Rubplayer
  class IO
    attr_accessor :stdscr, :header, :main_win, :status_bar

    def initialize(player)
      @player     = player
      @key_mapper = Rubplayer::KeyMapper.new

      @key_mapper.map('q') do
        :quit
      end

      @key_mapper.map('vv') do |n|
        @player.volume(n, true)
      end

      @key_mapper.map('vu') do |n|
        @player.volume(n, false)
      end

      @key_mapper.map('vd') do |n|
        @player.volume(-n, false)
      end

      init_curses; self
    end

    def init_curses
      Curses.init_screen
      Curses.raw
      Curses.nonl
      Curses.noecho

      @height = Curses.lines
      @width  = Curses.cols

      @header     = Rubplayer::Window.new(1, @width, 0, 0)
      @main_win   = Rubplayer::Window.new(@height - 2, @width, 1, 0)
      @status_bar = Rubplayer::Window.new(1, @width, @height - 1, 0)

      @header.bkgdset(3)
    end

    def print(str, window=@main_win, x=0, y=0)
      window.clear
      window.setpos(y, x)
      window << str
      window.refresh
    end

    def start_reactor
      while @current_key = @main_win.getch
        break if [:quit, :exit].include?(@key_mapper.trigger(@current_key))
      end
    end

    def clear(window=@main_win)
      window.clear
    end

    def close(*attr)
      Curses.close_screen
    end
  end
end
