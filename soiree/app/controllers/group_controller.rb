class GroupController < ApplicationController

  def new
  end

  def create
    @group = Group.new
    @users = User.find_by(group_users_params) ###
    GroupUsers.add_users(@group, @users)
    GroupPlaylists.create_playlists(@users, playlist_params)
  end


  private

  def playlist_params
    params = params.permit(:posts).return(  :name,
                                            :description,
                                            :playform_id)

    params[:preferences] = {genre: parmas[:post][:genre]}
    params
  end

  def group_users_params
    params = params.permit(:posts).return(:fb_ids)
  end

end
