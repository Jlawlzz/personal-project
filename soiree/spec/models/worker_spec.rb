require 'rails_helper'

RSpec.describe Worker, type: :model do

  it "checks for expired playlists" do
    Worker.update_personal_playlists
  end

  it "checks for expired groups" do
    Worker.update_group_playlists
  end

end
