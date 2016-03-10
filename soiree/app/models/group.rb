class Group < ActiveRecord::Base
  has_many :group_users
  has_many :users, through: :group_users
  has_many :group_playlists
  has_many :playlists, through: :group_playlists
  has_many :invites

  def self.create_group_playlist(playlist, spotify_user)
    group = playlist.groups[0]
    playlist.platform_create(spotify_user)
    saved_songs = group.grab_liked_songs
    group.group_populate(saved_songs)
  end

  def grab_liked_songs
    saved_songs = self.users.map do |user|
      platform = self.playlists.first.platform
      user_auth = user.find_token(platform).auth
      spotify_user = RSpotify::User.new(JSON.parse(user_auth))
      SpotifyService.new.retrieve_saved(spotify_user)
    end
    saved_songs
  end

  def group_populate(saved_songs)
    self.users.each do |user|
      platform = self.playlists.first.platform
      playlist = self.playlists.find_by(user_id: user.id)
      user_auth = user.find_token(platform).auth
      spotify_user = RSpotify::User.new(JSON.parse(user_auth))
      playlist.populate(spotify_user, saved_songs)
    end
  end

end
