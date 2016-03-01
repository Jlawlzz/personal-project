class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :image
      t.string :token
      t.datetime :expires_at
            
      t.timestamps null: false
    end
  end
end
