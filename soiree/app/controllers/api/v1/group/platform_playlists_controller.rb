class Api::V1::Group::PlatformPlaylistsController < Api::ApiController

  respond_to :json, :js

  def create
    playlist = Playlist.find(params[:id])
    Group.create_group_playlist(playlist, spotify_user)
    @playlist = playlist

    respond_to do |format|
      format.js
    end
  end

  def update




  end

end
