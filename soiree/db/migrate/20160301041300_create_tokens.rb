class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      enable_extension 'hstore'
      t.hstore :auth
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
