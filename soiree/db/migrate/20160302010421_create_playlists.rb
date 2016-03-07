class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      enable_extension 'hstore'
      t.string :name
      t.string :description
      t.hstore :preferences
      t.string :service_playlist_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
