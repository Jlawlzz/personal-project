require 'rails_helper'

RSpec.describe EchonestService, type: :model do

  it "finds spotify tracks" do

    songs = ["4N0VFSI2wJu2NzwUuI0sMz", "0YqxF5zwV8a0UbBPW2xHaH",
             "32SXFj9DD0ECBQYjr8Xrk7","0f420tG76j3felLh9TMUMq",
             "4jzRvmHo5owQBLa7tNH5gL", "7yj6i3TaFhBvxbLGejrvfw",
             "6tuZKBiS1p6Ig0UtC0ii0Y", "4v36nWrqRSwPlCQgQsb7Wx",
             "6r6PdNfFFx4ttC98mj03Oi", "3Zya4lXzYb2mW4FneXJX8e"]

    VCR.use_cassette("find_by_spotify") do
      @songs = EchonestService.find_by_spotify(songs)
    end

    expect(@songs.count).to eq 5
    expect(@songs.first.class).to eq Echowrap::Song
  end

  it "creates playlist from seed tracks" do

    songs = ["4N0VFSI2wJu2NzwUuI0sMz", "0YqxF5zwV8a0UbBPW2xHaH",
             "32SXFj9DD0ECBQYjr8Xrk7","0f420tG76j3felLh9TMUMq",
             "4jzRvmHo5owQBLa7tNH5gL", "7yj6i3TaFhBvxbLGejrvfw",
             "6tuZKBiS1p6Ig0UtC0ii0Y", "4v36nWrqRSwPlCQgQsb7Wx",
             "6r6PdNfFFx4ttC98mj03Oi", "3Zya4lXzYb2mW4FneXJX8e"]

    VCR.use_cassette("find_by_spotify") do
      @songs = EchonestService.find_by_spotify(songs)
    end

    VCR.use_cassette("retrieve_playlist_from_likes") do
      @suggested_songs = EchonestService.retrieve_playlist_from_likes(@songs)
    end

    expect(@suggested_songs.count).to eq 30
    expect(@suggested_songs.class).to eq Array
    expect(@suggested_songs.first.class).to eq String
  end


end
