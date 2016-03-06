class Group < ActiveRecord::Base
  has_many :group_users
  has_many :users, through: :group_users
  has_many :group_playlists
  has_many :playlists, through: :group_playlists
end
