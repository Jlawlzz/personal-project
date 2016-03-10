class Group::InvitesController < ApplicationController

  def index
    @invites = current_user.invites
  end

  def update
    invite = Invite.find(params[:id])
    group = invite.group
    playlist = group.update_group(invite, current_user)

    redirect_to group_playlist_path(playlist.id)
  end

  def destroy
    invite = Invite.find(params[:id])
    invite.destroy
    redirect_to dashboard_path
  end

end
