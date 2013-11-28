module Rubplayer
  module PlaybackInfo
    def get_playback_info(file)
      info = {}
      TagLib::FileRef.open(file) do |fileref|
        tag = fileref.tag; info[:tag] = {}
        info[:tag][:title]   = tag.title
        info[:tag][:artist]  = tag.artist
        info[:tag][:album]   = tag.album
        info[:tag][:year]    = tag.year
        info[:tag][:track]   = tag.track
        info[:tag][:genre]   = tag.genre
        info[:tag][:comment] = tag.comment

        properties = fileref.audio_properties; info[:properties] = {}
        info[:properties][:length] = properties.length
      end

      info
    end
  end
end
