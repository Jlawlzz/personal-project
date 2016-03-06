OmniAuth.config.logger = Rails.logger

module OmniAuth
  module Strategies
    class Spotify < OmniAuth::Strategies::OAuth2
      option :name, 'spotify'

      option :client_options, {
        site:          'https://api.spotify.com/v1/',
        authorize_url: 'https://accounts.spotify.com/authorize',
        token_url:     'https://accounts.spotify.com/api/token',
      }

      def info
        @raw_info ||= access_token.get('me').parsed
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

Echowrap.configure do |config|
  config.api_key =       ENV['ECHO_KEY']
  config.consumer_key =  ENV['ECHO_CONSUMER']
  config.shared_secret = ENV['ECHO_SECRET']
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], scope: 'user_friends'
  provider :spotify, ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET'], scope: 'user-read-email user-read-birthdate user-read-private user-library-modify user-library-read user-follow-read user-follow-modify streaming playlist-modify-private playlist-modify-public playlist-read-collaborative playlist-read-private'
end
