class FacebookService

  def self.login(auth)
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

end
