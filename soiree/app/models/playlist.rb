class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs


  def populate(user_auth)
    songs = fetch_songs_by_platform
    sanitized_songs = sanitize(songs)
    spotify_save(sanitized_songs, user_auth)
  end

  def fetch_songs_by_platform
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify" then songs = self.spotify_personal_logic
    end
    songs
  end

  def spotify_personal_logic
    Personal::SpotifyLogic.find_songs(self.preferences)
  end

  def sanitize(songs)
    songs.map do |song|
      song if !(self.songs.find_by(track_id: song))
    end
  end

  def spotify_save(sanitized_songs, user_auth)
    tracks = spotify_fetch(sanitized_songs)
    playlist = spotify_create_playlist(user_auth)
    playlist.add_tracks!(tracks)
    save_songs(tracks)
  end

  def save_songs(tracks)
    tracks.each do |song|
      artists = song.artists.map {|artist| artist.name}.join(', ')
      self.songs << Song.create(title: song.name, track_id: song.id, artist: artists, platform_id: self.platform_id)
    end
  end

  def spotify_fetch(sanitized_songs)
    SpotifyService.fetch_songs(sanitized_songs).first(30)
  end

  def spotify_create_playlist(user_auth)
    user_auth.create_playlist!(self.name)
  end

end
