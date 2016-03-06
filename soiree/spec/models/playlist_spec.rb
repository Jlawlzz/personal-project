require 'rails_helper'

RSpec.describe Playlist, type: :model do

  it "name_params" do
    playlist1 = Playlist.create(name: "THIS IS SO COOOOOOOOL")
    playlist2 = Playlist.create(name: "Woot something")
    expect(playlist1.name_params).to eq "THIS IS SO COOOO..."
    expect(playlist2.name_params).to eq "Woot something"
  end

  it "sanitize playlist" do
    playlist = Playlist.create(name: "Darkness")
    songs = []
    new_songs = [1,4,5]
    3.times do |n|
      songs <<  Song.create(track_id: n)
    end
    playlist.songs << songs
    sanitized_songs = playlist.sanitize(new_songs)
    expect(sanitized_songs.count).to eq 2
    expect(sanitized_songs).to eq [4, 5]
  end

  it "sends back 30 song " do
    VCR.use_cassette("returns songs") do
      playlist = Playlist.create(preferences: {'type'=> 'personal', 'genre'=> 'rap'})
    expect(playlist.spotify_split.count).to eq 77
    end
  end

end
