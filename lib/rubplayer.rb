# Standard libraries of Ruby
require 'rubygems'
require 'pty'
require 'thread'
require 'curses'

# Gems
require 'workflow'
require 'taglib'

require 'rubplayer/version'

module Rubplayer
  autoload :Term,          'rubplayer/term'
  autoload :PlaybackInfo,  'rubplayer/playback_info'
  autoload :Playback,      'rubplayer/playback'
  autoload :Playlist,      'rubplayer/playlist'
  autoload :Commands,      'rubplayer/commands'
  autoload :Window,        'rubplayer/window'
  autoload :IO,            'rubplayer/io'
  autoload :Player,        'rubplayer/player'
  autoload :KeyMapper,     'rubplayer/key_mapper'
  autoload :CommandParser, 'rubplayer/command_parser'
end
