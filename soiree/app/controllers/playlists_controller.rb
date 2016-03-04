class PlaylistsController < ApplicationController

  def new
    @playlist = Playlist.new
  end

  def create
    playlist = Playlist.create(playlist_params)
    playlist.populate(spotify_user)
    current_user.playlists << playlist
    
    redirect_to playlist_path(playlist.id)
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  private

  def playlist_params
    e = params.require(:post).permit( :name,
                                      :description,
                                      :platform_id)

    e[:preferences] = {genre: params[:post][:genre]}
    e
  end
end
