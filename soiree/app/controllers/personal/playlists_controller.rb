class Personal::PlaylistsController < ApplicationController

  def new
    @playlist = Playlist.new
  end

  def create
    playlist = Playlist.create(playlist(params))
    current_user.playlists << playlist
    # playlist.platform_create(spotify_user)
    # songs = current_user.grab_liked_songs(spotify_user)
    # playlist.populate(spotify_user, songs)
    # current_user.playlists << playlist
    @playlist = playlist

    redirect_to personal_playlist_path(playlist.id)
  end

  def show
    @playlist = playlist_owner?
  end

  def destroy
    playlist = Playlist.find(params['id'])
    playlist.playlist_songs.delete_all
    playlist.destroy

    redirect_to dashboard_path
  end

  private

  def playlist(params)
    playlist_params = params.require(:post).permit( :name,
                                      :description,
                                      :platform_id)

    playlist_params[:preferences] = {genre: params[:post][:genre], type: 'personal'}
    playlist_params
  end
end
