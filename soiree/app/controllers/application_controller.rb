class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user, :spotify_user, :facebook_user
  before_action :authorize!

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_permission
    @current_permission ||= PermissionService.new(current_user)
  end

  def authorized?
    current_permission.allow?(params[:controller], params[:action])
  end

  def authorize!
    unless authorized?
      redirect_to root_url
    end
  end

  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_auth]) if session[:spotify_auth]
  end

  def facebook_user
    @facebook_user ||= Koala::Facebook::API.new(current_user.token)
  end

  def playlist_owner?
    if current_user.playlists.include?(Playlist.find(params[:id]))
      Playlist.find(params[:id])
    else
      redirect_to dashboard_path
    end
  end

end
