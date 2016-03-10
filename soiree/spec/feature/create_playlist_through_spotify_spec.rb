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

    visit '/personal/playlists/new'

    expect(current_path).to eq '/personal/playlists/new'
    find(:xpath, "//input[@id='personal_name']").set "Boss"
    find(:xpath, "//input[@id='personal_description']").set "Coolio"
    click_on "Create Playlist"

    playlist = Playlist.first

    expect(current_path).to eq "/personal/playlists/#{playlist.id}"

    expect(page).to have_content "fresh tracks coming your way, hang tight!"

  end
end
