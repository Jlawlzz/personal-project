class GroupPlaylist < ActiveRecord::Base
  belongs_to :group
  belongs_to :playlist
end
