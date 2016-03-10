require 'rails_helper'

RSpec.describe Group::InvitesController, type: :controller do
  include Capybara::DSL

  describe "index" do
    it "shows all invites" do
      spotify = Platform.create(name: 'spotify')

       VCR.use_cassette("returns user login") do
         visit '/'
         click_on "login with facebook"
         click_link "Login to Spotify"
       end

       user = User.last

     ApplicationController.any_instance.stub(:current_user).and_return(user)


      group = Group.create
      playlist = Playlist.create(name: "thing")
      group.playlists << playlist
      invite = Invite.create(status: "pending")
      group.invites << invite
      user.invites << invite

      visit '/'

      expect(page).to have_link "Invites: 1"

      click_link 'Invites: 1'
      expect(current_path).to eq '/group/invites'

    end
  end
end
