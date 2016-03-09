require 'rails_helper'

RSpec.describe Api::V1::Personal::PlatformPlaylistsController, type: :controller do

  describe "#create" do
   it "responds with all customers" do

     Platform.create(name: 'spotify')
     Platform.create(name: 'soundcloud')

     VCR.use_cassette("returns user") do
       visit '/'
       click_on "login with facebook"
       click_link "Login to Spotify"
     end

     playlist = Playlist.create(name: "jordans jamz",
                                description: "yellow!"
                                )
     user = User.last
     user.playlists << playlist

     post :create, format: :json, id: playlist.id

     expect(response).to be_success

     binding.pry
    end
  end

end
