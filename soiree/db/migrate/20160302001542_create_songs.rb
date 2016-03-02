class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :track_id
      t.string :title
      t.string :artist
      t.string :album
      t.string :image
      t.references :platform, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
