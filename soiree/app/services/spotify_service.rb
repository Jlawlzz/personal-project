class SpotifyService

  def initialize
    RSpotify::authenticate(ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET'])
  end

  # Does artist_dump need to be in there??
  def retrieve_saved(user_auth, genre)
    tracks = user_auth.saved_tracks(limit: 30)
    artist_dump = []
    unique_songs = []
    tracks.each do |track|
      unique_songs << track.id if !artist_dump.include?(track.artists[0].id)
      artist_dump << track.artists[0].id
    end
    find_recommandations(unique_songs, genre)
  end

  def find_recommandations(unique_songs, genre)
  s = RSpotify::Recommendations.generate(limit: 20,
                                       seed_genres: [genre],
                                       seed_tracks: unique_songs[0..3],
                                       min_popularity: 50)
                                       binding.pry
                                       s.tracks
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

  def save_playlist(sanitized_songs, user_auth, playlist)
    sanitized_songs = sanitized_songs.map do |song|
      song.id
    end
    tracks = fetch_songs(sanitized_songs)
    playlist = RSpotify::Playlist.find(user_auth.id, playlist.service_playlist_id)
    # binding.pry
    refresh_playlist(playlist, tracks)
  end

  def fetch_songs(sanitized_songs)
    RSpotify::Track.find(sanitized_songs.first(30))
  end

  def create_playlist(playlist_name, user_auth)
    user_auth.create_playlist!(playlist_name + ' - Tango')
  end

  def refresh_playlist(playlist, tracks)
    playlist.replace_tracks!(tracks)
  end

end
