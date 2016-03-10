class EchonestService

  def self.find_by_spotify(tracks)
    tracks[0..4].map do |track|
      Echowrap.song_profile(track_id: "spotify:track:#{track}")
    end
  end

  def self.retrieve_playlist_from_likes(echo_songs)
    echo_ids = echo_songs.compact.map {|song| song.id }
    playlist = Echowrap.playlist_static(song_id: echo_ids[0..4],
                                        type: "artist-radio",
                                        bucket: ['id:spotify', 'tracks'],
                                        results: 30,
                                        :variety => 1,
                                        :song_selection => "song_discovery-top")
    playlist = playlist.map do |song|
      if song.attrs[:tracks][0][:foreign_id]
        song.attrs[:tracks][0][:foreign_id].split(':')[2]
      end
    end
    playlist
  end

end
