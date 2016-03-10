# require 'rails_helper'
#
# RSpec.describe Api::V1::Personal::PlatformPlaylistsController, type: :controller do
#   include Capybara::DSL
#
#   describe "#create" do
#    it "responds with playlist" do
#
#      spotify = Platform.create(name: 'spotify')
#      Platform.create(name: 'soundcloud')
#
#      VCR.use_cassette("returns user") do
#        visit '/'
#        click_on "login with facebook"
#        click_link "Login to Spotify"
#      end
#
#      user = User.last
#      ApplicationController.any_instance.stub(:current_user).and_return(user)
#
#      playlist = Playlist.create(name: "jordans jamz",
#                                 description: "yellow!",
#                                 platform_id: spotify.id
#                                 )
#
#      user.playlists << playlist
#
#     post :create, format: :json, id: playlist.id
#
#
#      expect(response).to be_success
#
#      binding.pry
#     end
#   end
#
# end
