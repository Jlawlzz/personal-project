require 'rails_helper'

RSpec.describe Api::V1::Group::PlatformPlaylistsController, type: :controller do
  include Capybara::DSL

  describe "#create" do
   it "responds with playlist" do

     spotify = Platform.create(name: 'spotify')
     Platform.create(name: 'soundcloud')

     VCR.use_cassette("returns user") do
       visit '/'
       click_on "login with facebook"
       click_link "Login to Spotify"
     end

     token = JSON.parse("{\"provider\":\"spotify\",\"uid\":null,\"info\":{\"birthdate\":\"1991-10-30\",\"country\":\"US\",\"display_name\":\"Jordan Lawler\",\"email\":\"werepeople2@gmail.com\",\"external_urls\":{\"spotify\":\"https://open.spotify.com/user/1232734959\"},\"followers\":{\"href\":null,\"total\":30},\"href\":\"https://api.spotify.com/v1/users/1232734959\",\"id\":\"1232734959\",\"images\":[{\"height\":null,\"url\":\"https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/p200x200/10356392_10153021679733622_6315879785094839761_n.jpg?oh=48470f963afa3c575e6bf2a642d350b8\\u0026oe=575C550E\",\"width\":null}],\"product\":\"premium\",\"type\":\"user\",\"uri\":\"spotify:user:1232734959\",\"name\":\"werepeople2@gmail.com\"},\"credentials\":{\"token\":\"BQDfbDWGUcGOLdsSUj9KLwy8k22acBfn28CKYAhi4-W8bjz8yqfnhxLpry0d5zhqT297NLD4pO5-tSIjGsxH56WdjXVPW56kM_AQeG2ARAzjbtFSRYGmRcj_DRYkNcQUmNcAGDQWfRM-bsEu0upSutzQLa9nyx8jwI2haC1jOvUXCtydi6TqPvM57RgY-xqBJsd8mattIeI9fpYUnSnIrRY8ugbLsFnMtxPdjREGUpW7QAehcBibcIzr5NZxWBV37H9kyBoJ2I_j0JJKH7hEyZoYqC_LkqbDzIeM7tph7I7-E2QOAVau\",\"refresh_token\":\"AQAr6B-sK3BzM88sxISAmGbiMBC7VWXumfjIxLCi79TcO3f9luNT6YiZJObLHEb5L2GDRkZPDXQgnRSoF1aR0BBjhqJDgAGQ7UKZu18lg04iVXdWEhdgHYJE54ZFi06Kqxg\",\"expires_at\":1457577373,\"expires\":true},\"extra\":{}}"
 )
     spotify_user = RSpotify::User.new(token)

     user = User.last
     ApplicationController.any_instance.stub(:current_user).and_return(user)
     ApplicationController.any_instance.stub(:spotify_user).and_return(spotify_user)

     token = Token.create(platform_id: spotify.id,
                          auth:"{\"provider\":\"spotify\",\"uid\":null,\"info\":{\"birthdate\":\"1991-10-30\",\"country\":\"US\",\"display_name\":\"Jordan Lawler\",\"email\":\"werepeople2@gmail.com\",\"external_urls\":{\"spotify\":\"https://open.spotify.com/user/1232734959\"},\"followers\":{\"href\":null,\"total\":30},\"href\":\"https://api.spotify.com/v1/users/1232734959\",\"id\":\"1232734959\",\"images\":[{\"height\":null,\"url\":\"https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/p200x200/10356392_10153021679733622_6315879785094839761_n.jpg?oh=48470f963afa3c575e6bf2a642d350b8\\u0026oe=575C550E\",\"width\":null}],\"product\":\"premium\",\"type\":\"user\",\"uri\":\"spotify:user:1232734959\",\"name\":\"werepeople2@gmail.com\"},\"credentials\":{\"token\":\"BQDfbDWGUcGOLdsSUj9KLwy8k22acBfn28CKYAhi4-W8bjz8yqfnhxLpry0d5zhqT297NLD4pO5-tSIjGsxH56WdjXVPW56kM_AQeG2ARAzjbtFSRYGmRcj_DRYkNcQUmNcAGDQWfRM-bsEu0upSutzQLa9nyx8jwI2haC1jOvUXCtydi6TqPvM57RgY-xqBJsd8mattIeI9fpYUnSnIrRY8ugbLsFnMtxPdjREGUpW7QAehcBibcIzr5NZxWBV37H9kyBoJ2I_j0JJKH7hEyZoYqC_LkqbDzIeM7tph7I7-E2QOAVau\",\"refresh_token\":\"AQAr6B-sK3BzM88sxISAmGbiMBC7VWXumfjIxLCi79TcO3f9luNT6YiZJObLHEb5L2GDRkZPDXQgnRSoF1aR0BBjhqJDgAGQ7UKZu18lg04iVXdWEhdgHYJE54ZFi06Kqxg\",\"expires_at\":1457577373,\"expires\":true},\"extra\":{}}"
 )

    user.tokens << token

     playlist = Playlist.create(name: "jordans jamz",
                                description: "yellow!",
                                platform_id: spotify.id
                                )
     group = Group.create
     group.playlists << playlist
     user.playlists << playlist

     VCR.use_cassette("create_group_playlist") do
       post :create, format: :js, id: playlist.id
     end

     visit "personal/playlists/#{playlist.id}"

     expect(response).to be_success
     expect(page).to have_content("jordans jamz")
     expect(page).to have_content("yellow!")
    end
  end

end
