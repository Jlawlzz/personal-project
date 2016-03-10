class Group::PlaylistsController < ApplicationController

  def new
    @playlist = Playlist.new
    @friends = facebook_user.get_connections('me', 'friends')
  end

  def show
    @playlist = playlist_owner?
    @users = @playlist.groups.first.users
  end

  def create
    @playlist = Playlist.new(playlist_params(params))
    if @playlist.save
      group = Group.create
      ids = group_users_params['fb_ids']
      Invite.send_invite(ids, group)
      group.users << current_user
      group.playlists << @playlist
      current_user.playlists << @playlist

      redirect_to group_playlist_path(@playlist.id)
    else
      @friends = facebook_user.get_connections('me', 'friends')
      render :new
    end
  end

  def destroy
    playlist = Playlist.find(params[:id])
    playlist.group_playlists.destroy_all
    playlist.playlist_songs.destroy_all
    playlist.destroy
    redirect_to dashboard_path
  end

  private

  def playlist_params(params)
    playlist_params = params.require(:post).permit( :name,
                                      :description,
                                      :platform_id)

    playlist_params[:preferences] = {genre: params[:post][:genre], type: 'group'}
    playlist_params
  end

  def group_users_params
    params.permit(:fb_ids)
  end

end
