class Api::V1::Group::PlatformPlaylistsController < Api::ApiController

  respond_to :json, :js

  def create
    playlist = Playlist.find(params[:id])
    group = playlist.groups[0]
    playlist.platform_create(spotify_user)
    saved_songs = group.grab_liked_songs
    group.group_populate(saved_songs)
    @playlist = playlist

    respond_to do |format|
      format.js
    end
  end

  def update




  end

end
