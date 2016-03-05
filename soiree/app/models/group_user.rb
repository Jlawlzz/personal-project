class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group


  def add_users(users)

  end
end
