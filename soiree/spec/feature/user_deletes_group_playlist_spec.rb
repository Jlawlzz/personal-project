require 'rails_helper'

RSpec.describe "User can delete a group playlist" do
  include Capybara::DSL
  scenario "User has a playlist in a group and deletes it" do

    user = User.create!(token: ENV['FRIEND_SECRET'],
                         uid: ENV['FRIEND_APP_ID'],
                         name: "Jordan Lawler",
                         provider: "facebook"
                         )
    user2 = User.create!(token: ENV['FRIEND_SECRET'],
                        uid: ENV['FRIEND_APP_ID'],
                        name: "Jordan Lawler",
                        provider: "facebook"
                        )

    ApplicationController.any_instance.stub(:current_user).and_return(user)
    ApplicationController.any_instance.stub(:spotify_user).and_return(user)


    playlist = Playlist.create(name: "Yay")
    playlist.songs << Song.create(title: "I Believe!")
    group = Group.create()
    group.playlists << playlist
    user.playlists << playlist
    user.groups << group
    user2.groups << group

    visit "/group/playlists/#{playlist.id}"

    expect(page).to have_content "Yay"
    expect(page).to have_content "I Believe!"

    click_on "Remove Playlist"

    expect(current_path).to eq "/dashboard"
    expect(user.playlists.count).to eq 0
  end
end
