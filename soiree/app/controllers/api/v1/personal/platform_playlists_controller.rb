class Api::V1::Personal::PlatformPlaylistsController < Api::ApiController
  respond_to :json

  def create
    playlist = Playlist.find(params[:id])
    binding.pry
    playlist.platform_create(spotify_user)
    binding.pry
    songs = current_user.grab_liked_songs(spotify_user)
    binding.pry
    playlist.populate(spotify_user, songs)
    current_user.playlists << playlist
    @playlist = playlist

    respond_to do |format|
      format.js
    end
  end

end
