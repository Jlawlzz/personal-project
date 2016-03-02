class DashboardController < ApplicationController

  def show
    # @groups = Group.find_by(user_id: params[:id])
    # binding.pry
    @user_playlist = Playlist.where(user_id: current_user.id)
  end

end
