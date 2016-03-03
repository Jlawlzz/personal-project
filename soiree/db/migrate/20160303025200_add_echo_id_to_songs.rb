class AddEchoIdToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :echo_id, :string, default: "no_id"
  end
end
