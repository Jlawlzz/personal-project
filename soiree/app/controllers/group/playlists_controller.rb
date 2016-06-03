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
    create_redirect
  end

  def destroy
    playlist = Playlist.find(params[:id])
    delete_group_invites(playlist)
    delete_group_redirect(playlist)
  end

  private

  def delete_group_redirect(playlist)
    playlist.group_playlists.destroy_all
    playlist.playlist_songs.destroy_all
    playlist.destroy
    redirect_to dashboard_path
  end

  def delete_group_invites(playlist)
    # When a group member deletes their portion of the group playlist, their image should be taken off other group
    # Members pages
    group = playlist.groups[0]
    group.destroy
    # if GroupUser.where(group: group_id).length == 1
      # Determine if there is only one person in the group
      # Iterate through and delete the invites if any
      # else
      # Iterate through and delete the user from the group playlist
    # end
  end

  def create_redirect
    if Platform.find(params['post']['platform_id']).name != 'spotify'
      flash[:warning] = "Sorry, this platform is not yet supported. Check back soon!"
      redirect_to new_group_playlist_path
    elsif params['post']['genre'].downcase != 'all'
      flash[:warning] = "Sorry, genres are not yet supported. Check back soon!"
      redirect_to new_group_playlist_path
    elsif params['post']['description'] == ""
      flash[:warning] = "Playlists must have a description!"
      redirect_to new_group_playlist_path
    else
      @playlist = Playlist.new(playlist_params(params))
      create_group_redirect(params)
    end
  end

  def create_group_redirect(params)
    if @playlist.save
      group = Group.create
      group.create_group(current_user, params, @playlist)
      redirect_to group_playlist_path(@playlist.id)
    else
      @friends = facebook_user.get_connections('me', 'friends')
      render :new
    end
  end

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
