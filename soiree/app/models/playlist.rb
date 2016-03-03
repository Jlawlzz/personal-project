class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs


  def populate(user_auth)
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify" then songs = self.spotify_songs
    end
    sanitized_songs = sanitize(songs)
    doin_shit(sanitized_songs, user_auth)
  end

  def spotify_songs
    Personal::SpotifyLogic.find_songs(self.preferences)
  end

  def sanitize(songs)
    songs.map do |song|
      song if !(self.songs.find_by(track_id: song))
    end
  end

  def doin_shit(sanitized_songs, user_auth)
    tracks = SpotifyService.fetch_songs(sanitized_songs)
    playlist = user_auth.create_playlist!(self.name)
    playlist.add_tracks!(tracks.first(30))
    tracks.each do |song|
      artists = song.artists.map {|artist| artist.name}.join(', ')
      self.songs << Song.create(title: song.name, track_id: song.id, artist: artists, platform_id: self.platform_id)
    end
  end

end
