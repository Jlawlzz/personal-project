class AddPlatformIdToPlaylists < ActiveRecord::Migration
  def change
    add_reference :playlists, :platform, index: true, foreign_key: true
  end
end
