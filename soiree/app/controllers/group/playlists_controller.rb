class Group::PlaylistsController < ApplicationController

  def new
    @friends = facebook_user.get_connections('me', 'friends')
  end

  def create
    binding.pry
    @group = Group.new
    @users = User.find_by(group_users_params)
    @group.users <<  @users
    @group.playlist << Playlist.create(playlist_params)

    redirect_to group_playlist_path
  end


  private

  def playlist_params
    params = params.permit(:posts).return(  :name,
                                            :description,
                                            :playform_id)

    params[:preferences] = {genre: parmas[:post][:genre]}
    params[:preferences] = {style: 'group'}
    params
  end

  def group_users_params
    params = params.permit(:posts).return(:fb_ids)
  end

end
