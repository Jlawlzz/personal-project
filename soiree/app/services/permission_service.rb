class PermissionService
  extend Forwardable

  attr_reader :controller, :action, :user

  def_delegators :user, :user?,
                        :spotify?

  def initialize(user)
    @user = user ||= User.new
  end

  def allow?(controller, action)
    @controller = controller
    @action = action
    case
    when user? then user_permissions
    else
      guest_user_permissions
    end
  end

  private

  def user_permissions
    return true if controller == "sessions"
    return true if controller == "dashboard"
    return true if controller == "spotify"
    return true if controller == "personal/playlists"
    return true if controller == "group/playlists"
    return true if controller == "home"
    return true if controller == "group/invites"
    return true if controller == "api/v1/personal/platform_playlists"
    return true if controller == "api/v1/group/platform_playlists"
  end

  def guest_user_permissions
    return true if controller == "sessions"
    return true if controller == "home"
  end

end
