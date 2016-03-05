require 'rails_helper'

RSpec.describe "User can create a group" do
  include Capybara::DSL
  scenario "create a 30 long song playlist" do

    Platform.create(name: 'spotify')

    VCR.use_cassette("returns user") do
      visit '/'
      click_on "login with facebook"
      click_link "Login to Spotify"
    end

    expect(current_path).to eq '/dashboard'
    visit '/group_playlist/new'

    expect(current_path).to eq '/group_playlist/new'

    #SELECT GROUP MEMEBERS
    fill_in "Name", with: "Boss"
    fill_in "Description", with: "Coolio"
    expect(page).to have_content "Preferences"

    #select friends
    #only show friends that are in spotify
    click_on "Create Playlist"

    #Populate music based off of users


  #
  #   playlist = Playlist.first
  #   expect(current_path).to eq playlist_path(playlist.id)
  #
  #   expect(20).to eq playlist.songs.count
  #
  end
end
