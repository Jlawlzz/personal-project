class SpotifyController < ApplicationController

  def create
    binding.pry
    spotify_user = User.spotify_login(env["omniauth.auth"])
    session[:spotify] = spotify_user
    redirect_to dashboard_path
  end

end
