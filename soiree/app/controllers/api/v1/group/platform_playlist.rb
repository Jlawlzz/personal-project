class Api::V1::Group::PlatformPlaylist < Api::ApiController

  def create
    playlist.platform_create(spotify_user)
    saved_songs = group.grab_liked_songs
    group.group_populate(saved_songs)

    respond_to do |format|
      format.js
    end
  end
  
end
