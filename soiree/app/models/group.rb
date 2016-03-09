class Group < ActiveRecord::Base
  has_many :group_users
  has_many :users, through: :group_users
  has_many :group_playlists
  has_many :playlists, through: :group_playlists
  has_many :invites


  def send_invites
    self.users.each do |user|
      invite = Invite.create(status: 'pending')
      user.invites << invite
      self.invites << invite
    end
  end

  def update_playlists(controller)
    self.users.each do |user|
      platform = self.playlists.first.platform
      playlist = self.playlists.find_by(user_id: user.id)
      token = user.find_token(platform)
      spotify_group_user = RSpotify::User.new(JSON.parse(token.auth))
    end
    playlist.populate(spotify_group_user, controller)
  end

end
