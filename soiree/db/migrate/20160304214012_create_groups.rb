class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :playlist, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
