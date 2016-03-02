class User < ActiveRecord::Base
  has_many :tokens
  has_many :platforms, through: :tokens
  has_many :playlists

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

  def self.spotify_login(auth, current_user)
    spotify_user = RSpotify::User.new(auth)
    spotify = Platform.find_by(name: 'spotify')
    user = User.find(current_user.id)
    token = Token.create(key: spotify_user.credentials['token'], platform_id: spotify.id)
    user.tokens << token
    binding.pry
  end
end
