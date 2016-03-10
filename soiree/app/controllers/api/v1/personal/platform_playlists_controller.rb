class Api::V1::Personal::PlatformPlaylistsController < Api::ApiController

  respond_to :json, :js

  def create
    playlist = Playlist.find(params[:id])
    playlist.platform_create(spotify_user)
    songs = current_user.grab_liked_songs(spotify_user)
    playlist.populate(spotify_user, songs)
    current_user.playlists << playlist
    @playlist = playlist

    respond_to do |format|
      format.js
    end
  end

end
