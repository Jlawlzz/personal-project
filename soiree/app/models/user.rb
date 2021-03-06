class User < ActiveRecord::Base
  has_many :tokens
  has_many :platforms, through: :tokens
  has_many :playlists
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :invites

  def find_token(platform)
    self.tokens.find_by(platform_id: platform)
  end

  def self.facebook_login(auth)
    FacebookService.login(auth)
  end

  def self.spotify_login(auth, current_user)
    SpotifyService.login(auth, current_user)
  end

  def user_playlists
    self.playlists.where("preferences @> 'type=>personal'")
  end

  def group_playlists
    self.playlists.where("preferences @> 'type=>group'")
  end

  def user?
    provider == 'facebook'
  end

  def create_personal_playlist(spotify_user, playlist)
    playlist.platform_create(spotify_user)
    songs = playlist.user_tracks_saved_by_platform(spotify_user)
    playlist.populate(spotify_user, songs)
    self.playlists << playlist
  end

  def grab_liked_songs(user_auth)
    SpotifyService.new.retrieve_saved(user_auth)
  end

end
