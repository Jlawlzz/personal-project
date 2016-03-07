class Group::PlaylistsController < ApplicationController

  def new
    @friends = facebook_user.get_connections('me', 'friends')
    @playlist = Playlist.new
  end

  def create
    @group = Group.create
    @users = User.find_by(uid: group_users_params['fb_ids'])
    @group.users <<  @users
    @group.users << current_user
    @group.users.each do |user|
      token = user.tokens.find_by(platform_id: Platform.find(params[:post][:platform_id]))
      spotify_group_user = RSpotify::User.new(JSON.parse(token.auth))
      playlist = Playlist.create(playlist_params(params))
      @group.playlists << playlist
      playlist.populate(spotify_group_user)
      user.playlists << playlist
    end
    playlist = @group.playlists.find_by(user_id: current_user.id)
    redirect_to group_playlist_path(playlist.id)
  end

  def show
    @playlist = Playlist.find(params[:id])
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
