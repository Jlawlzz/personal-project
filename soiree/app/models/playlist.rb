class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs
  has_many :group_playlists
  has_many :groups, through: :group_playlists
  belongs_to :platform

  def name_params
    if self.name.length > 18
      self.name[0..15] + "..."
    else
      self.name[0..15]
    end
  end

  def populate(user_auth)
    songs = fetch_songs_by_platform
    sanitized_songs = sanitize(songs)
    tracks = save_songs_by_platform(sanitized_songs, user_auth)
    save_songs(tracks)
  end

  def platform_type
    self.platform.name
  end

  def fetch_songs_by_platform
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify" then songs = fetch_spotify_songs
    end
    songs
  end

  def fetch_spotify_songs
    @spotify_service = SpotifyService.new
    @spotify_service.return_playlist(self.preferences)
  end

  def save_songs_by_platform(sanitized_songs, user_auth)
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify" then tracks = @spotify_service.save_playlist(sanitized_songs, user_auth, self.name)
    end
    tracks
  end

  def sanitize(songs)
    songs.map do |song|
      song if !(self.songs.find_by(track_id: song))
    end.compact
  end

  def save_songs(tracks)
    tracks.each do |song|
      artists = song.artists.map {|artist| artist.name}.join(', ')
      self.songs << Song.create(title: song.name,
                                track_id: song.id,
                                artist: artists,
                                platform_id: self.platform_id,
                                image: song.album.images[2]['url'],
                                album: song.album.name)
    end
  end

end
