class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :logged_in?

  private

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインが必要です"
    end
  end

  # 一般ユーザーが管理者か（ロールはこのアプリ内の設定）
  def dashboard_path_by_role
    if current_user.admin?
      admin_root_path
    else
      users_path
    end
  end
end
