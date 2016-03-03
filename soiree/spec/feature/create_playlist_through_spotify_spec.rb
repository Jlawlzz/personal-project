require 'rails_helper'

RSpec.describe "User can create a playlist" do
  include Capybara::DSL
  scenario "create a 20 long song playlist" do

    Platform.create(name: 'spotify')
    Platform.create(name: 'soundcloud')

    VCR.use_cassette("returns user") do
      visit '/'
      click_on "login with facebook"
      click_link "Login to Spotify"
    end
    expect(current_path).to eq '/dashboard'
    expect(page).to_not have_content "Login to Spotify"

    visit '/playlists/new'

    expect(current_path).to eq '/playlists/new'

    fill_in "Name", with: "Boss"
    fill_in "Description", with: "Coolio"
    # expect(page).to have_content "Preferences"
    click_on "Create Playlist"

    playlist = Playlist.first
    expect(current_path).to eq playlist_path(playlist.id)

    expect(20).to eq playlist.songs.count

  end
end
