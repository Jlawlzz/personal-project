class User < ActiveRecord::Base
  has_many :tokens
  has_many :platforms, through: :tokens
  has_many :playlists
  has_many :group_users
  has_many :groups, through: :group_users

  def self.omniauth(auth)
    user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid'])

    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.image = auth.info.image
    user.token = auth.credentials.token
    user.expires_at = Time.at(auth.credentials.expires_at)
    user.save!
    user
  end

  def user_playlists
    self.playlists
  end

  def self.spotify_login(auth, current_user)
    spotify = Platform.find_by(name: 'spotify')

    if !current_user.platforms.where(name: 'spotify').empty?
      token = current_user.tokens.where(platform: {name: 'spotify'})
    else
      token = Token.create(auth: auth.to_json, platform_id: spotify.id)
      current_user.tokens << token
    end
    token
  end
end
