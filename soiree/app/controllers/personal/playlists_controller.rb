class Personal::PlaylistsController < ApplicationController

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(playlist_params(params))

    create_redirect
  end

  def show
    @playlist = playlist_owner?
  end

  def destroy
    playlist = Playlist.find(params['id'])

    delete_redirect(playlist)
  end

  private

  def playlist_params(params)
    playlist_params = params.require(:post).permit(:name,
                                      :description,
                                      :platform_id)

    playlist_params[:preferences] = {genre: params[:post][:genre], type: 'personal'}
    playlist_params
  end

  def create_redirect
    if @playlist.save
      current_user.playlists << @playlist
      redirect_to personal_playlist_path(@playlist.id)
    else
      render :new
    end
  end

  def delete_redirect(playlist)
    playlist.playlist_songs.delete_all
    playlist.destroy

    redirect_to dashboard_path
  end
end
