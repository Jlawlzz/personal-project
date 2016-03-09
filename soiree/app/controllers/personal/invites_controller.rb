class Personal::InvitesController < ApplicationController

  def index
    @invites = current_user.invites
  end

  def update
    invite = Invite.find(params[:id])
    group = invite.group
    playlist_clone = group.playlists.first
    playlist = Playlist.create(name: playlist_clone.name,
                               description: playlist_clone.description,
                               preferences: playlist_clone.preferences,
                               platform_id: playlist_clone.platform_id)
    current_user.playlists << playlist
    group.users << current_user
    group.playlists << playlist
    playlist.platform_create(spotify_user)
    saved_songs = group.grab_liked_songs
    group.group_populate(saved_songs)
    invite.destroy

    redirect_to group_playlist_path(playlist.id)
  end

end
