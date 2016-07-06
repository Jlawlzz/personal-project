class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs
  has_many :group_playlists, dependent: :destroy
  has_many :groups, through: :group_playlists
  belongs_to :platform
  belongs_to :service_playlist
  validates :name, presence: true
  before_destroy :destroy_songs


  brad = Playlist.new

  def destroy_songs
    Song.destroy(self.songs.pluck(:id))
  end

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

  def platform_create(user_auth)
    playlist = create_playlist_by_platform(user_auth).id
    self.update_attribute(:service_playlist_id, playlist)
  end

  def populate(user_auth, tracks)
    sanitized_songs = sanitize_songs(tracks)
    tracks = save_songs_by_platform(sanitized_songs, user_auth)
    save_songs_to_db(tracks)
  end

  def user_tracks_saved_by_platform(user_auth)
    platform = Platform.find(self.platform_id)
    genre = self.preferences['genre']
    case platform.name
    when "spotify"
      @spotify_service = SpotifyService.new
      saved_songs = @spotify_service.retrieve_saved(user_auth)
      recommended_songs = @spotify_service.find_recommandations(saved_songs, genre)
    end
    recommended_songs
  end

  def sanitize_songs(tracks)
    # tracks.map! do |song|
    #   song if !(self.songs.find_by(track_id: song))
    # end.compact!
    tracks
  end

  def save_songs_by_platform(sanitized_songs, user_auth)
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify"
      @spotify_service = SpotifyService.new
      tracks = @spotify_service.save_playlist(sanitized_songs, user_auth, self)
    end
    tracks
  end

  def save_songs_to_db(tracks)
    self.playlist_songs.destroy_all
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

  def create_playlist_by_platform(user_auth)
    platform = Platform.find(self.platform_id)
    case platform.name
    when "spotify"
      @spotify_service = SpotifyService.new
      @spotify_service.create_playlist(self.name, user_auth)
    end
  end

end
