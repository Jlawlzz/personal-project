require 'rails_helper'

RSpec.describe "User can create a group" do
  include Capybara::DSL
  scenario "create a 30 long song playlist" do

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
      find(:css, "#Lawler").set(true)
    end

    VCR.use_cassette("spotify#client_auth") do
      click_on "Create Playlist"
    end
    playlist = Playlist.find_by(user_id: User.all.last)

    expect(current_path).to eq "/group/playlists/#{playlist.id}"

    expect(page).to have_content "fresh tracks coming your way, hang tight!"
  end
end
