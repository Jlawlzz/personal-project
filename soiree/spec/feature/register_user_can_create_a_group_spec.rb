require 'rails_helper'

RSpec.describe "User can create a group" do
  include Capybara::DSL
  scenario "create a 30 long song playlist" do

    platform = Platform.create(name: 'spotify')

    friend = User.create(token: "CAAKC85ZBVS88BALkdjSKZCiCjcyeDEPNM0eXEZBtwfnnb09hlvuypi4B4sbeEfZCR8hwmt5hNgs4jdbaZBsuZCtKQZB0P7zJJXVuKYjHeq5nZBFlWjNjUh3SQgvEx69rmTSaAdx553nY0ixEloh2ZAnZAHyaZCYGrncMxSwlhuBlEDj9upnQNexSROGngsZCd8iZCmZBQ0BoElr0AqjQZDZD",
                         uid: "10153958223763622",
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

      #SELECT GROUP MEMEBERS
      fill_in 'name:', with: "Boss"
      fill_in 'description:', with: "Coolio"
      expect(page).to have_content "preferences:"

      find(:css, "#Stinnette").set(false)
      #only show friends that are in spotify
    end

    VCR.use_cassette("spotify#client_auth") do
      click_on "Create Playlist"
    end

    playlist = Playlist.find_by(user_id: User.all.last)

    expect(current_path).to eq "/group/playlists/#{playlist.id}"

    30.times do |t|
      expect(page).to have_content(playlist.songs[t].title)
      expect(page).to have_content(playlist.songs[t].album)
      expect(page).to have_content(playlist.songs[t].artist)
    end
  end
end
