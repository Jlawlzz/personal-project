require 'rails_helper'

RSpec.describe "User can delete a group playlist" do
  include Capybara::DSL
  context "User creates a playlist" do

  def setup
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
    playlist = Playlist.create(name: "Yay")
    playlist_clone = Playlist.create(name: "Yay")
    playlist.songs << Song.create(title: "I Believe!")
    playlist_clone.songs << Song.create(title: "I Believe!")

    group = Group.create()
    GroupPlaylist.create(playlist_id: playlist.id, group_id: group.id)
    GroupPlaylist.create(playlist_id: playlist_clone.id, group_id: group.id)

    user.playlists << playlist
    user2.playlists << playlist_clone
    user.groups << group
    user2.groups << group
  end

    it "one user can remove the playlist" do
      setup
      user = User.first
      user2 = User.last
      playlist = user.playlists.first
      ApplicationController.any_instance.stubs(:spotify_user).returns(user)
      ApplicationController.any_instance.stubs(:current_user).returns(user)


      visit "/group/playlists/#{playlist.id}"

      expect(page).to have_content "Yay"
      expect(page).to have_content "I Believe!"
      expect(user.playlists.count).to eq 1
      expect(GroupPlaylist.all.count).to eq 2
      expect(Song.all.count).to eq 2
      expect(Group.all.count).to eq 1

      click_on "Remove Playlist"

      expect(current_path).to eq "/dashboard"
      expect(user.playlists.count).to eq 0
      expect(user2.playlists.count).to eq 1
      expect(GroupPlaylist.all.count).to eq 1
      expect(Playlist.all.count).to eq 1
      expect(Song.all.count).to eq 1
      expect(Group.all.count).to eq 1

      ApplicationController.any_instance.stubs(:current_user).returns(user2)
      ApplicationController.any_instance.stubs(:spotify_user).returns(user2)

      playlist = user2.playlists.first
      visit "/group/playlists/#{playlist.id}"

      expect(page).to have_content "Yay"
      expect(page).to have_content "I Believe!"
      expect(user2.playlists.count).to eq 1

      click_on "Remove Playlist"

      expect(current_path).to eq "/dashboard"
      expect(user2.playlists.count).to eq 0
      expect(GroupPlaylist.all.count).to eq 0
      expect(Playlist.all.count).to eq 0
      expect(Song.all.count).to eq 0
      expect(Group.all.count).to eq 0
    end
  end
end
