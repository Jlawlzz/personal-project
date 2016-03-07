class Personal::InvitesController < ApplicationController

  def index
    @invites = current_user.invites
  end

  def update
    invite = Invite.find(params[:id])
    group = invite.group
    current_user.tokens.find_by(platform_id: group.playlists.first.platform)
    playlist_clone = group.playlists.first
    playlist = Playlist.create(name: playlist_clone.name,
                               description: playlist_clone.description,
                               preferences: playlist_clone.preferences,
                               platform_id: playlist_clone.platform_id)
    current_user.playlists << playlist
    group.playlists << playlist
    playlist.create(spotify_user)
    group.update_playlists(params['controller'])
    invite.destroy
    redirect_to group_playlist_path(playlist.id)
  end

  def destroy
    invite = Invite.find(params[:id])
    invite.destroy
    redirect_to dashboard_path
  end

end
