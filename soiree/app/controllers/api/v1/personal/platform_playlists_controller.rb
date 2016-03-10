class Api::V1::Personal::PlatformPlaylistsController < Api::ApiController

  respond_to :json, :js

  def create
    @playlist = Playlist.find(params[:id])
    current_user.create_personal_playlist(spotify_user, @playlist)

    respond_to do |format|
      format.js
    end
  end

end
