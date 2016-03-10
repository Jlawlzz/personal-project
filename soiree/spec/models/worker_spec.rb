require 'rails_helper'

RSpec.describe Worker, type: :model do

  it "checks for expired playlists" do
    Worker.update_personal_playlists
  end

  it "checks for expired groups" do
    Worker.update_group_playlists
  end

  it "populates for personal playlist" do

    spotify = Platform.create(name: 'spotify')

    token = JSON.parse("{\"provider\":\"spotify\",\"uid\":null,\"info\":{\"birthdate\":\"1991-10-30\",\"country\":\"US\",\"display_name\":\"Jordan Lawler\",\"email\":\"werepeople2@gmail.com\",\"external_urls\":{\"spotify\":\"https://open.spotify.com/user/1232734959\"},\"followers\":{\"href\":null,\"total\":30},\"href\":\"https://api.spotify.com/v1/users/1232734959\",\"id\":\"1232734959\",\"images\":[{\"height\":null,\"url\":\"https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/p200x200/10356392_10153021679733622_6315879785094839761_n.jpg?oh=48470f963afa3c575e6bf2a642d350b8\\u0026oe=575C550E\",\"width\":null}],\"product\":\"premium\",\"type\":\"user\",\"uri\":\"spotify:user:1232734959\",\"name\":\"werepeople2@gmail.com\"},\"credentials\":{\"token\":\"BQDfbDWGUcGOLdsSUj9KLwy8k22acBfn28CKYAhi4-W8bjz8yqfnhxLpry0d5zhqT297NLD4pO5-tSIjGsxH56WdjXVPW56kM_AQeG2ARAzjbtFSRYGmRcj_DRYkNcQUmNcAGDQWfRM-bsEu0upSutzQLa9nyx8jwI2haC1jOvUXCtydi6TqPvM57RgY-xqBJsd8mattIeI9fpYUnSnIrRY8ugbLsFnMtxPdjREGUpW7QAehcBibcIzr5NZxWBV37H9kyBoJ2I_j0JJKH7hEyZoYqC_LkqbDzIeM7tph7I7-E2QOAVau\",\"refresh_token\":\"AQAr6B-sK3BzM88sxISAmGbiMBC7VWXumfjIxLCi79TcO3f9luNT6YiZJObLHEb5L2GDRkZPDXQgnRSoF1aR0BBjhqJDgAGQ7UKZu18lg04iVXdWEhdgHYJE54ZFi06Kqxg\",\"expires_at\":1457577373,\"expires\":true},\"extra\":{}}"
)
    @user_auth = RSpotify::User.new(token)

    playlist = Playlist.create(name: "yo", platform_id: spotify.id)

    user = User.create(name: "Jordan", uid: '1')

    user.playlists << playlist

    token = Token.create(auth: token.to_json, platform_id: spotify.id)

    user.tokens << token

    VCR.use_cassette("playlist_created_for_platorm") do
      playlist.platform_create(@user_auth)
    end

    VCR.use_cassette("playlist_finds_saved_tracks") do
      @songs = playlist.user_tracks_saved_by_platform(@user_auth)
    end

    VCR.use_cassette("playlist_populates_tracks_2_electric_boogaloo") do
      @playlist = playlist.populate(@user_auth, @songs)
    end

    VCR.use_cassette("playlists_updates_via_worker") do
      Worker.personal_populate(playlist, "test")
    end

    expect(playlist.songs.count).to eq 30
  end

end
