module Rubplayer
  class IO
    attr_accessor :mode

    def initialize(player, mode=:curses)
      @player     = player
      @mode       = mode
      @key_mapper = Rubplayer::KeyMapper.new

      @key_mapper.map('q') do
        :quit
      end

      send("init_#{@mode}")
    end

    def init_curses
      Curses.init_screen
      Curses.raw
      Curses.nonl
      Curses.noecho
      @stdscr = Curses.stdscr
      @stdscr.keypad(true)
      @stdscr.setpos(0, 0)
    end

    def print(*attr)
      send("print_#{@mode}", *attr)
    end

    def print_curses(str, window=@stdscr, x=nil, y=nil)
      # TODO: consinder windows and x & y position
      window.addstr(str)
      window.refresh
    end

    def start_reactor(*attr)
      send("start_reactor_#{@mode}", *attr)
    end

    def start_reactor_curses(window=@stdscr)
      while @current_key = @stdscr.getch
        break if [:quit, :exit].include?(@key_mapper.trigger(@current_key))
      end
    end

    def close(*attr)
      send("close_#{@mode}", *attr)
    end

    def close_curses(*attr)
      Curses.close_screen
    end
  end
end
