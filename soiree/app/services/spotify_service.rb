class SpotifyService

  def self.fetch_songs(sanitized_songs)
    RSpotify::Track.find(sanitized_songs.first(30))
  end

  def self.refresh_playlist(playlist, tracks)
    playlist.add_tracks!(tracks)
  end

end
