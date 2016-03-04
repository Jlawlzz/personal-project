class Personal::SpotifyLogic
  
  def self.find_songs(preferences)
    artist = Echowrap.artist_search(description: preferences['genre'])
    artist = artist.first.attrs
    songs = Echowrap.song_search(artist: artist[:name], results: 100, bucket: ['id:spotify', 'tracks'])
    t = songs.map do |song|
      song.attrs[:tracks][0][:foreign_id].split(':')[2] if !(song.attrs[:tracks].empty?)
    end.compact
  end
end
