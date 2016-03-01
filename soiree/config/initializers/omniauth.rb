require 'rspotify/oauth'
OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :spotify, ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET'], :provider_ignores_state => true 

end
