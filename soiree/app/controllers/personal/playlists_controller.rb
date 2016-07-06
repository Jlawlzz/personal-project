class Personal::PlaylistsController < ApplicationController

  def new
    @playlist = Playlist.new
  end

  def create
    create_redirect
  end

  def show
    @playlist = playlist_owner?
  end

  def destroy
    playlist = Playlist.find(params['id'])
    playlist.destroy
    redirect_to dashboard_path
  end

  private

  def playlist_params(params)
    playlist_params = params.require(:post).permit(:name,
                                      :description,
                                      :platform_id,
                                      )
    playlist_params[:preferences] = {genre: params[:post][:genre],
                                     type: 'personal',
                                     popularity: params[:slider]
                                    }
    playlist_params
  end

  def create_redirect
    if Platform.find(params['post']['platform_id']).name != 'spotify'
      flash[:warning] = "Sorry, this platform is not yet supported. Check back soon!"
      redirect_to new_personal_playlist_path
    # elsif params['post']['genre'].downcase != 'all'
    #   flash[:warning] = "Sorry, genres are not yet supported. Check back soon!"
      # redirect_to new_personal_playlist_path
    elsif params['post']['description'] == ""
      flash[:warning] = "Playlists must have a description!"
      redirect_to new_personal_playlist_path
    else
      @playlist = Playlist.new(playlist_params(params))
      create_playlist_redirect
    end
  end

  def create_playlist_redirect
    if @playlist.save
      current_user.playlists << @playlist
      redirect_to personal_playlist_path(@playlist.id)
    else
      render :new
    end
  end

end
