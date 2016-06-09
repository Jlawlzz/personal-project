require 'rails_helper'

RSpec.describe "User can create a playlist" do
  include Capybara::DSL
  include WaitForAjax
  it "create a 20 long song playlist", js: true do
    Platform.create(name: 'spotify')


    # VCR.use_cassette("returns user") do
      visit '/'
      click_on "login with facebook"
      click_on "Login to Spotify"
      # click_link "Login to Spotify"
    # end
    sleep 2
    expect(current_path).to eq '/dashboard'
    expect(page).to_not have_content "Login to Spotify"

    visit '/personal/playlists/new'

    expect(current_path).to eq '/personal/playlists/new'
    find(:xpath, "//input[@id='personal_name']").set "Boss"
    find(:xpath, "//input[@id='personal_description']").set "Coolio"

    click_on "Create Playlist"
    wait_for_ajax

    playlist = Playlist.first
    expect(current_path).to eq "/personal/playlists/#{playlist.id}"
    expect(page).to have_content "fresh tracks coming your way, hang tight!"

    sleep 20
    expect(Playlist.all.count).to eq 1
    expect(Song.all.count).to eq 30
  end
end
