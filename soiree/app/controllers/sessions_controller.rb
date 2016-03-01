class SessionsController < ApplicationController

  def create
    user = User.omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
