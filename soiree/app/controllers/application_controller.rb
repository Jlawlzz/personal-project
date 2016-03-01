class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user, :spotify_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_auth]) if session[:spotify_auth]
  end

end
