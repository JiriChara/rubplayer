module Rubplayer
  class Playback
    include Workflow
    include Rubplayer::PlaybackInfo

    workflow do
      state :new do
        event :play, transitions_to: :playing
      end

      state :playing do
        event :stop,  transitions_to: :stopped
        event :pause, transitions_to: :paused
      end

      state :stopped do
        event :play, transitions_to: :playing
      end

      state :paused do
        event :play, transitions_to: :playing
        event :stop, transitions_to: :stopped
      end
    end

    def initialize(player)
      @player = player

      @player.on(:read) do |line|
        return unless playing?

        case line
        when %r{^Starting playback\.\.\.$}
          @player.io.print("Playback started.", @player.io.status_bar)
        when %r{^A:\s*(\d+\.\d+).*of\s*(\d+\.\d+)}
          pos, length = Time.at($1.to_i).utc.strftime('%R:%S'), Time.at($2.to_i).utc.strftime('%R:%S')
          @player.io.print("Playling... #{pos} of #{length}", @player.io.status_bar)
        end
      end
    end

    def play(file)
      @player.io.print("Starting playback of #{file}", @player.io.status_bar)
      @player.loadfile(file)
    end
  end
end
