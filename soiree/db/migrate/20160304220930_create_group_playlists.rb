class CreateGroupPlaylists < ActiveRecord::Migration
  def change
    create_table :group_playlists do |t|
      t.references :group, index: true, foreign_key: true
      t.references :playlist, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
