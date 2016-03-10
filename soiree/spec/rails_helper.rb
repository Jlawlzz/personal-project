require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'vcr'
require 'capybara/rspec'
require 'mocha'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  VCR.configure do |c|
    c.cassette_library_dir = "spec/vcr"
    c.hook_into :webmock
  end

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
    {"provider"=>"facebook",
      "uid"=>ENV['FACEBOOK_APP_ID'],
      "info"=>{"email"=>"tmoore2272@gmail.com", "name"=>"Taylor Moore", "image"=>"http://graph.facebook.com/10156565555460075/picture"},
      "credentials"=>
      {"token"=> ENV["TEST_SECRET"],
        "expires_at"=>1461986493,
        "expires"=>true},
        "extra"=>{"raw_info"=>{"name"=>"Taylor Moore", "email"=>"tmoore2272@gmail.com", "id"=>"10156565555460075"}}})

OmniAuth.config.mock_auth[:spotify] = OmniAuth::AuthHash.new({"provider"=>"spotify",
 "uid"=>nil,
 "info"=>
  {"birthdate"=>"1990-02-22",
   "country"=>"US",
   "display_name"=>"Taylor Moore",
   "email"=>"tmoore2272@gmail.com",
   "external_urls"=>{"spotify"=>"https://open.spotify.com/user/1247992398"},
   "followers"=>{"href"=>nil, "total"=>10},
   "href"=>"https://api.spotify.com/v1/users/1247992398",
   "id"=>"1247992398",
   "images"=>
    [{"height"=>nil,
      "url"=>
       "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p200x200/12195846_10156171544960075_8004671535216847355_n.jpg?oh=07dbb813d263e117412a6f27a86e1bf9&oe=574E5AD7",
      "width"=>nil}],
   "product"=>"open",
   "type"=>"user",
   "uri"=>"spotify:user:1247992398"},
 "credentials"=>
  {"token"=>
    ENV["SPOTIFY_CLIENT_TOKEN"],
   "refresh_token"=>
    ENV["SPOTIFY_CLIENT_REFRESH"],
   "expires_at"=>1456944208,
   "expires"=>true},
 "extra"=>{}} )

 def spotify_friend_user_token
   ({"provider"=>"spotify",
    "uid"=>nil,
    "info"=>
     {"birthdate"=>"1990-02-22",
      "country"=>"US",
      "display_name"=>"Taylor Moore",
      "email"=>"tmoore2272@gmail.com",
      "external_urls"=>{"spotify"=>"https://open.spotify.com/user/1247992398"},
      "followers"=>{"href"=>nil, "total"=>10},
      "href"=>"https://api.spotify.com/v1/users/1247992398",
      "id"=>"1247992398",
      "images"=>
       [{"height"=>nil,
         "url"=>
          "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p200x200/12195846_10156171544960075_8004671535216847355_n.jpg?oh=07dbb813d263e117412a6f27a86e1bf9&oe=574E5AD7",
         "width"=>nil}],
      "product"=>"open",
      "type"=>"user",
      "uri"=>"spotify:user:1247992398"},
    "credentials"=>
     {"token"=>
       ENV["SPOTIFY_CLIENT_TOKEN"],
      "refresh_token"=>
       ENV["SPOTIFY_CLIENT_REFRESH"],
      "expires_at"=>1456944208,
      "expires"=>true},
    "extra"=>{}}).to_json
 end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

end
