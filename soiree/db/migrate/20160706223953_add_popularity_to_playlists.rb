class AddPopularityToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :min_pop, :integer
    add_column :playlists, :max_pop, :integer
  end
end
