class Worker


  def self.update_personal_playlist
    playlists = find_expired_playlists
    refresh_playlist(playlists)
  end

  def self.find_expired_playlists
    # time = Time.now - 7.days
    # time2 = time - 7.days
    time = Time.now - 60
    time2 = Time.now - 7.dayss
    Playlist.where({updated_at: time..time2})
  end

  def self.refresh_playlist(playlists)
    playlist.each do |playlist|
      songs = playlist.user.grab_liked_songs
      user = playlist.user.tokens.where(name: "spotify")
      playlist.populate(user, songs)
      sleep(60)
  end

end
