require 'rails_helper'

RSpec.describe Song, type: :model do
  it "truncates song" do
    song = Song.create(title: "asdf;lkasjdfkjawehfkajgfaklsg;akljg;aslkjg",
                       artist: "aksldjf;aslkhjg;sEklgha;skhg;awket;wakeht;askl",
                       album: "a;lskdjg;aslkehg;sakhg;aksndfewjkfn;awejfh;ajkhf")

    title = song.truncate('title')
    artist = song.truncate('artist')
    album = song.truncate('album')

    expect(title.length).to eq 26
    expect(artist.length).to eq 26
    expect(album.length).to eq 26
  end
end
