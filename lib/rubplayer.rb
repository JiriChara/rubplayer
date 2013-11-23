require 'pty'
require 'thread'
require 'curses'

require 'aasm'

require 'rubplayer/version'

module Rubplayer
  autoload :Term,      'rubplayer/term'
  autoload :Commands,  'rubplayer/commands'
  autoload :IO,        'rubplayer/io'
  autoload :Player,    'rubplayer/player'
  autoload :KeyMapper, 'rubplayer/key_mapper'
end

Rubplayer::Player.new do
  on(:read) do |line|
  end

  loadlist "http://amp.cesnet.cz:8000/cro-radio-wave-256.ogg.m3u"
end
