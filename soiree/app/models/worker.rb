  class Worker

  def self.update_personal_playlists
    playlists = find_expired_playlists
    refresh_playlists(playlists)
  end

  def self.update_group_playlists
    groups = find_expired_groups
    refresh_groups(groups)
  end

  def self.find_expired_playlists
    time = Time.now - 7.days
    time2 = time - 7.days

    Playlist.where({updated_at: time2..time})
  end

  def self.find_expired_groups
    time = Time.now - 7.days
    time2 = time - 7.days

    Group.where({updated_at: time2..time})
  end

  def self.refresh_playlists(playlists)
    playlists.each do |playlist|
      personal_populate(playlist)
    end
  end

  def self.refresh_groups(groups)
    groups.each do |group|
      group_populate(group)
      group.update_attribute(:updated_at, Time.now)
    end
  end

  def self.group_populate(group, env="dev")
    songs = group.grab_liked_songs
    group.group_populate(songs)
    sleep(30) if env == "dev"
  end

  def self.personal_populate(playlist, env="dev")
    platform = Platform.where(name: "spotify").last
    user = playlist.user.tokens.find_by(platform_id: platform.id)
    user = RSpotify::User.new(JSON.parse(user.auth))
    songs = playlist.user.grab_liked_songs(user)
    playlist.populate(user, songs)
    sleep(60) if env == "dev"
  end

end
