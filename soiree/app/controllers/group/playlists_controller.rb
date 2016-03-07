class Group::PlaylistsController < ApplicationController
  def new
    @playlist = Playlist.new
    @friends = facebook_user.get_connections('me', 'friends')
  end

  def show
    @playlist = playlist_owner?
  end

  def create
    group = Group.create
    users = User.find_by(uid: group_users_params['fb_ids'])
    group.users <<  users
    group.send_invites
    group.users << current_user
    current_user.find_token(params[:post][:platform_id])
    playlist = Playlist.create(playlist_params(params))
    group.playlists << playlist
    current_user.playlists << playlist
    playlist.create(spotify_user)

    redirect_to group_playlist_path(playlist.id)
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
