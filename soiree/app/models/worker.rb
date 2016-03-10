class Worker

  def self.update_personal_playlists
    playlists = find_expired_playlists
    refresh_playlist(playlists)
  end

  def self.find_expired_playlists
    time = Time.now - 7.days
    time2 = time - 7.days

    Playlist.where({updated_at: time2..time})
  end

  def self.refresh_playlist(playlists)
    playlists.each do |playlist|
      user = playlist.user.tokens.find_by(platform_id: Platform.find_by(name: "spotify"))
      user = RSpotify::User.new(JSON.parse(user.auth))
      songs = playlist.user.grab_liked_songs(user)
      playlist.populate(user, songs)
      sleep(60)
    end
  end

end
