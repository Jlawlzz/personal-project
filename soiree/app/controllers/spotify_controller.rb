class SpotifyController < ApplicationController

  def create
    @user = User.spotify_login(request.env["omniauth.auth"], current_user)
    session[:spotify_auth] = request.env["omniauth.auth"]
    redirect_to dashboard_path
  end

end
