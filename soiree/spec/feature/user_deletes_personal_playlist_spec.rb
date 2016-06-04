require 'rails_helper'

RSpec.describe "User can delete a personal playlist" do
  include Capybara::DSL
  context "creates a playlist" do

  def setup
    user = User.create!(token: ENV['FRIEND_SECRET'],
                         uid: ENV['FRIEND_APP_ID'],
                         name: "Jordan Lawler",
                         provider: "facebook"
                         )

    playlist = Playlist.create(name: "Yay")
    playlist.songs << Song.create(title: "I Believe!",
                                  artist: 'R. Kelly',
                                  album: 'Dah Hits'
                                  )

    user.playlists << playlist
  end

    it "removes that playlist" do
      setup
      user = User.first
      playlist = user.playlists.first
      ApplicationController.any_instance.stubs(:spotify_user).returns(user)
      ApplicationController.any_instance.stubs(:current_user).returns(user)


      visit "/personal/playlists/#{playlist.id}"

      expect(page).to have_content "Yay"
      expect(page).to have_content "I Believe!"
      expect(user.playlists.count).to eq 1
      expect(PlaylistSong.all.count).to eq 1
      expect(Song.all.count).to eq 1

      click_on "Remove Playlist"

      expect(current_path).to eq "/dashboard"
      expect(user.playlists.count).to eq 0

      expect(Playlist.all.count).to eq 0
      expect(Song.all.count).to eq 0
      expect(PlaylistSong.all.count).to eq 0
    end
  end
end
