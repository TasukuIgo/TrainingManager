class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path unless current_user
  end

  def dashboard_path_by_role
    if current_user.admin?
      admin_root_path
    else
      users_path
    end
  end
end
