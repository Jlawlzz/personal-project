class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :group


  def self.send_invite(user_ids, group)
    users = User.find_by(uid: user_ids)
    users = [users] if ([users].count == 1)
    users.each do |user|
      invite = Invite.create(status: 'pending', group_id: group.id)
      user.invites << invite
    end
  end

end
