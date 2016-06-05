require 'rails_helper'

RSpec.describe "User can create a group" do
  include Capybara::DSL
  context "and delete the group" do
    it "which deletes the invites" do

      platform = Platform.create(name: 'spotify')

      friend = User.create!(token: ENV['FRIEND_SECRET'],
                           uid: ENV['FRIEND_APP_ID'],
                           name: "Jordan Lawler",
                           provider: "facebook"
                           )
      token = Token.create(auth: spotify_friend_user_token)
      friend.tokens << token
      platform.tokens << token

      VCR.use_cassette("returns user") do
        visit '/'
        click_on "login with facebook"
      end

      click_link "Login to Spotify"

      Token.all.first.update_attribute(:user_id, friend.id)

      expect(current_path).to eq '/dashboard'

      VCR.use_cassette("echonest_service#genre") do

        visit '/group/playlists/new'

        expect(current_path).to eq '/group/playlists/new'

        fill_in 'name:', with: "Boss"
        fill_in 'description:', with: "Coolio"
        find(:css, "#Andrew").set(true)
      end

      VCR.use_cassette("spotify#client_auth") do
        click_on "Create Playlist"
      end
      playlist = Playlist.find_by(user_id: User.all.last)

      expect(current_path).to eq "/group/playlists/#{playlist.id}"
      #
      # VCR.user_cassette('spotify#songs') do
      #
      # end
      expect(page).to have_content "fresh tracks coming your way, hang tight!"

      expect(User.last.playlists.count).to eq 1
      expect(GroupPlaylist.all.count).to eq 1
      # expect(Song.all.count).to eq 2
      expect(Group.all.count).to eq 1
      expect(Invite.all.count).to eq 1

      click_on "Remove Playlist"

      expect(current_path).to eq '/dashboard'
      expect(Invite.all.count).to eq 0
      expect(Playlist.all.count).to eq 0
      expect(GroupPlaylist.all.count).to eq 0
      # expect(Song.all.count).to eq 2
      expect(Group.all.count).to eq 0

    end
  end
end
