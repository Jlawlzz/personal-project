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

  def platform_type
    self.platform.name
  end

  def genres
    [ "All", "Rap", "Country", "Hip-hop",
      "Jazz", "Alternative", "Rock", "Punk"].sort
  end

  def populate(user_auth)
    songs = fetch_songs_by_platform
    sanitized_songs = sanitize(songs)
    spotify_save(sanitized_songs, user_auth)
  end

  def fetch_songs_by_platform
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify" then songs = self.spotify_split
    end
    songs
  end

  def spotify_split
    case self.preferences['type']
    when "personal" then Personal::SpotifyLogic.find_songs(self.preferences)
    when "group" then Group::SpotifyLogic.find_songs(self.preferences)
    end
  end

  def sanitize(songs)
    songs.map do |song|
      song if !(self.songs.find_by(track_id: song))
    end.compact
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
      self.songs << Song.create(title: song.name,
                                track_id: song.id,
                                artist: artists,
                                platform_id: self.platform_id,
                                image: song.album.images[2]['url'],
                                album: song.album.name,
                                link: song.external_urls["spotify"])
    end
  end

  def spotify_fetch(sanitized_songs)
    SpotifyService.fetch_songs(sanitized_songs).first(30)
  end

  def spotify_create_playlist(user_auth)
    RSpotify::authenticate(ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET'])
    user_auth.create_playlist!(self.name + ' - Soriee')
  end

  def spotify_delete_playlist(spotify_user, playlist)
    spotify_user.delete_playlist!(self.name + ' - Soriee')
  end

end
