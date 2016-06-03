class Group < ActiveRecord::Base
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, dependent: :destroy
  belongs_to :playlist, dependent: :destroy
  has_many :invites, dependent: :destroy

  def self.create_group_playlist(playlist, spotify_user)
    group = playlist.groups[0]
    playlist.platform_create(spotify_user)
    saved_songs = group.grab_liked_songs
    group.group_populate(saved_songs)
  end

  def create_group(user, params, playlist)
    Invite.send_invite(params['fb_ids'], self)
    self.users << user
    self.playlist = playlist
    playlist.groups << self
    user.playlists << playlist
  end

  def update_group(invite, user)
    playlist_clone = self.playlist
    playlist = Playlist.create(name: playlist_clone.name,
                               description: playlist_clone.description,
                               preferences: playlist_clone.preferences,
                               platform_id: playlist_clone.platform_id)
                               binding.pry
    user.playlists << playlist
    self.playlist = playlist
    self.users << user
    playlist.groups << self
    invite.destroy
    playlist
  end

  def grab_liked_songs
    saved_songs = self.users.map do |user|
      platform = self.playlist.platform
      user_auth = user.find_token(platform).auth
      spotify_user = RSpotify::User.new(JSON.parse(user_auth))
      SpotifyService.new.retrieve_saved(spotify_user)
    end
    saved_songs
  end

  def group_populate(saved_songs)
    self.users.each do |user|
      playlist = self.playlist
      platform = playlist.platform
      user_auth = user.find_token(platform).auth
      spotify_user = RSpotify::User.new(JSON.parse(user_auth))
      playlist.populate(spotify_user, saved_songs)
    end
  end

end
