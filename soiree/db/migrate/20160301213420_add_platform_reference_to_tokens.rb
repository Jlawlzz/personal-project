class AddPlatformReferenceToTokens < ActiveRecord::Migration
  def change
    add_reference :tokens, :platform, index: true, foreign_key: true
  end
end
