require 'rails_helper'

RSpec.describe "User can delete a group playlist" do
  include Capybara::DSL
  scenario "User has a playlist in a group and deletes it" do

    VCR.use_cassette("returns user") do
      visit '/'
      click_on "login with facebook"
      click_link "Login to Spotify"
    end
    ApplicationController.any_instance.stub(:current_user).and_return(user)

    platform = Platform.create(name: 'spotify')

    user = User.last
    playlist = Playlist.create(name: "Yay")
    playlist.songs << Song.create(name: "I Believe!")
    playlist.platform << platform
    group = Group.create(name: "Jams")
    group.playlists << playlist
    user.groups << group

    visit "/group/playlists/#{playlist.id}"

    expect(page).to have_content "Yay"
    expect(page).to have_content "I Believe!"

    # save_and_open_page
  end
end
