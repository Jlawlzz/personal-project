require 'rails_helper'

RSpec.describe "User can create a playlist", type: :feature do
  include Capybara::DSL
  include WaitForAjax
  it "create a 20 long song playlist", js: true do
    Platform.create(name: 'spotify')


    # VCR.use_cassette("returns user") do
      visit '/'
      click_on "login with facebook"
      click_link "Login to Spotify"
      wait_for_ajax
    # end

    expect(current_path).to eq '/dashboard'
    # expect(page).to_not have_content "Login to Spotify"

    visit '/personal/playlists/new'

    expect(current_path).to eq '/personal/playlists/new'
    find(:xpath, "//input[@id='personal_name']").set "Boss"
    find(:xpath, "//input[@id='personal_description']").set "Coolio"
    # option = find(:xpath, "//*[@id='post_platform_id']/option[0]").text
    # find('#post_platform_id').find(:xpath, 'option[0]').select_option
    # select "spotify", :from => "post_platform_id"
    sleep 25
    click_on "Create Playlist"
    wait_for_ajax
    wait_for_ajax

    playlist = Playlist.first

    # expect(current_path).to eq "/personal/playlists/#{playlist.id}"
    expect(page).to have_content "fresh tracks coming your way, hang tight!"
  end
end
