class SessionsController < ApplicationController

  def create
    binding.pry
    user = User.omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
