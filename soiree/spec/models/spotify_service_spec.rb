require 'rails_helper'

RSpec.describe SpotifyService, type: :model do

  it "retrieved_saved_tracks" do
    VCR.use_cassette("returns_spotify_user") do
      @ss = SpotifyService.new
    end

    token = JSON.parse("{\"provider\":\"spotify\",\"uid\":null,\"info\":{\"birthdate\":\"1991-10-30\",\"country\":\"US\",\"display_name\":\"Jordan Lawler\",\"email\":\"werepeople2@gmail.com\",\"external_urls\":{\"spotify\":\"https://open.spotify.com/user/1232734959\"},\"followers\":{\"href\":null,\"total\":30},\"href\":\"https://api.spotify.com/v1/users/1232734959\",\"id\":\"1232734959\",\"images\":[{\"height\":null,\"url\":\"https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/p200x200/10356392_10153021679733622_6315879785094839761_n.jpg?oh=48470f963afa3c575e6bf2a642d350b8\\u0026oe=575C550E\",\"width\":null}],\"product\":\"premium\",\"type\":\"user\",\"uri\":\"spotify:user:1232734959\",\"name\":\"werepeople2@gmail.com\"},\"credentials\":{\"token\":\"BQDfbDWGUcGOLdsSUj9KLwy8k22acBfn28CKYAhi4-W8bjz8yqfnhxLpry0d5zhqT297NLD4pO5-tSIjGsxH56WdjXVPW56kM_AQeG2ARAzjbtFSRYGmRcj_DRYkNcQUmNcAGDQWfRM-bsEu0upSutzQLa9nyx8jwI2haC1jOvUXCtydi6TqPvM57RgY-xqBJsd8mattIeI9fpYUnSnIrRY8ugbLsFnMtxPdjREGUpW7QAehcBibcIzr5NZxWBV37H9kyBoJ2I_j0JJKH7hEyZoYqC_LkqbDzIeM7tph7I7-E2QOAVau\",\"refresh_token\":\"AQAr6B-sK3BzM88sxISAmGbiMBC7VWXumfjIxLCi79TcO3f9luNT6YiZJObLHEb5L2GDRkZPDXQgnRSoF1aR0BBjhqJDgAGQ7UKZu18lg04iVXdWEhdgHYJE54ZFi06Kqxg\",\"expires_at\":1457577373,\"expires\":true},\"extra\":{}}"
)
    user_auth = RSpotify::User.new(token)

    VCR.use_cassette("returns_spotify_songs") do
      @songs = @ss.retrieve_saved(user_auth)
    end

    expect(@songs.count).to eq 10
  end

  it "creates_spotify_playlist" do
    VCR.use_cassette("returns_spotify_user") do
      @ss = SpotifyService.new
    end

    playlist = Playlist.new(name: "jamz")

    token = JSON.parse("{\"provider\":\"spotify\",\"uid\":null,\"info\":{\"birthdate\":\"1991-10-30\",\"country\":\"US\",\"display_name\":\"Jordan Lawler\",\"email\":\"werepeople2@gmail.com\",\"external_urls\":{\"spotify\":\"https://open.spotify.com/user/1232734959\"},\"followers\":{\"href\":null,\"total\":30},\"href\":\"https://api.spotify.com/v1/users/1232734959\",\"id\":\"1232734959\",\"images\":[{\"height\":null,\"url\":\"https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/p200x200/10356392_10153021679733622_6315879785094839761_n.jpg?oh=48470f963afa3c575e6bf2a642d350b8\\u0026oe=575C550E\",\"width\":null}],\"product\":\"premium\",\"type\":\"user\",\"uri\":\"spotify:user:1232734959\",\"name\":\"werepeople2@gmail.com\"},\"credentials\":{\"token\":\"BQDfbDWGUcGOLdsSUj9KLwy8k22acBfn28CKYAhi4-W8bjz8yqfnhxLpry0d5zhqT297NLD4pO5-tSIjGsxH56WdjXVPW56kM_AQeG2ARAzjbtFSRYGmRcj_DRYkNcQUmNcAGDQWfRM-bsEu0upSutzQLa9nyx8jwI2haC1jOvUXCtydi6TqPvM57RgY-xqBJsd8mattIeI9fpYUnSnIrRY8ugbLsFnMtxPdjREGUpW7QAehcBibcIzr5NZxWBV37H9kyBoJ2I_j0JJKH7hEyZoYqC_LkqbDzIeM7tph7I7-E2QOAVau\",\"refresh_token\":\"AQAr6B-sK3BzM88sxISAmGbiMBC7VWXumfjIxLCi79TcO3f9luNT6YiZJObLHEb5L2GDRkZPDXQgnRSoF1aR0BBjhqJDgAGQ7UKZu18lg04iVXdWEhdgHYJE54ZFi06Kqxg\",\"expires_at\":1457577373,\"expires\":true},\"extra\":{}}"
)

    VCR.use_cassette("return_spotify_user") do
      @user_auth = RSpotify::User.new(token)
    end

    VCR.use_cassette("creates_spotify_playlist") do
      @playlist = @ss.create_playlist(playlist.name, @user_auth)
    end

    expect(@playlist.id).to eq "0H5Fy7twVSRZ95trTnReWE"
    expect(@playlist.name).to eq "jamz - Tango"
    expect(@playlist.type).to eq "playlist"
  end

  it "saves_playlist" do
    VCR.use_cassette("returns_spotify_user") do
      @ss = SpotifyService.new
    end

    songs = ["4N0VFSI2wJu2NzwUuI0sMz", "0YqxF5zwV8a0UbBPW2xHaH",
             "32SXFj9DD0ECBQYjr8Xrk7","0f420tG76j3felLh9TMUMq",
             "4jzRvmHo5owQBLa7tNH5gL", "7yj6i3TaFhBvxbLGejrvfw",
             "6tuZKBiS1p6Ig0UtC0ii0Y", "4v36nWrqRSwPlCQgQsb7Wx",
             "6r6PdNfFFx4ttC98mj03Oi", "3Zya4lXzYb2mW4FneXJX8e"]

    token = JSON.parse("{\"provider\":\"spotify\",\"uid\":null,\"info\":{\"birthdate\":\"1991-10-30\",\"country\":\"US\",\"display_name\":\"Jordan Lawler\",\"email\":\"werepeople2@gmail.com\",\"external_urls\":{\"spotify\":\"https://open.spotify.com/user/1232734959\"},\"followers\":{\"href\":null,\"total\":30},\"href\":\"https://api.spotify.com/v1/users/1232734959\",\"id\":\"1232734959\",\"images\":[{\"height\":null,\"url\":\"https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/p200x200/10356392_10153021679733622_6315879785094839761_n.jpg?oh=48470f963afa3c575e6bf2a642d350b8\\u0026oe=575C550E\",\"width\":null}],\"product\":\"premium\",\"type\":\"user\",\"uri\":\"spotify:user:1232734959\",\"name\":\"werepeople2@gmail.com\"},\"credentials\":{\"token\":\"BQDfbDWGUcGOLdsSUj9KLwy8k22acBfn28CKYAhi4-W8bjz8yqfnhxLpry0d5zhqT297NLD4pO5-tSIjGsxH56WdjXVPW56kM_AQeG2ARAzjbtFSRYGmRcj_DRYkNcQUmNcAGDQWfRM-bsEu0upSutzQLa9nyx8jwI2haC1jOvUXCtydi6TqPvM57RgY-xqBJsd8mattIeI9fpYUnSnIrRY8ugbLsFnMtxPdjREGUpW7QAehcBibcIzr5NZxWBV37H9kyBoJ2I_j0JJKH7hEyZoYqC_LkqbDzIeM7tph7I7-E2QOAVau\",\"refresh_token\":\"AQAr6B-sK3BzM88sxISAmGbiMBC7VWXumfjIxLCi79TcO3f9luNT6YiZJObLHEb5L2GDRkZPDXQgnRSoF1aR0BBjhqJDgAGQ7UKZu18lg04iVXdWEhdgHYJE54ZFi06Kqxg\",\"expires_at\":1457577373,\"expires\":true},\"extra\":{}}"
)
    @user_auth = RSpotify::User.new(token)

    playlist = Playlist.new(name: "jamz")

    VCR.use_cassette("creates_spotify_playlist") do
      @playlist = @ss.create_playlist(playlist.name, @user_auth)
    end

    playlist.update_attribute(:service_playlist_id, @playlist.id)

    VCR.use_cassette("saves_playlist") do
      @songs = @ss.save_playlist(songs, @user_auth, playlist)
    end
    
    expect(@songs.count).to eq 10
  end


end
