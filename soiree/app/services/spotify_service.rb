class SpotifyService

  def initialize
    RSpotify::authenticate(ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET'])
  end

  def self.login(auth, current_user)
    spotify = Platform.find_by(name: 'spotify')
    if !current_user.platforms.where(name: 'spotify').empty?
      token = current_user.tokens.where(platform: {name: 'spotify'})
    else
      token = Token.create(auth: auth.to_json, platform_id: spotify.id)
      current_user.tokens << token
    end
    token
  end

  def return_playlist(preferences)
    playlist_type(preferences)
  end

  def playlist_type(preferences)
    case preferences['type']
    when "personal" then Personal::SpotifyLogic.find_songs(preferences)
    when "group" then Group::SpotifyLogic.find_songs(preferences)
    end
  end

  def save_playlist(sanitized_songs, user_auth, playlist)
    tracks = fetch_songs(sanitized_songs)
    playlist = RSpotify::Playlist.find(user_auth.id, playlist.service_playlist_id)
    refresh_playlist(playlist, tracks)
  end

  def fetch_songs(sanitized_songs)
    RSpotify::Track.find(sanitized_songs.first(30))
  end

  def create_playlist(playlist_name, user_auth)
    user_auth.create_playlist!(playlist_name + ' - Soriee')
  end

  def refresh_playlist(playlist, tracks)
    playlist.replace_tracks!(tracks)
  end

end
