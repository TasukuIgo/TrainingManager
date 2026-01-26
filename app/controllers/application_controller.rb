class ApplicationController < ActionController::Base
  # ログイン必須（ほとんどのコントローラで適用）
  before_action :require_login

  # ビューでも使えるようにメソッドを公開
  helper_method :current_user, :logged_in?

  private

  # 現在ログインしているユーザーを取得
  def current_user
    return @current_user if defined?(@current_user) # すでに取得済みなら DB を呼ばない
    @current_user = User.find_by(id: session[:user_id]) # session に保存された user_id から取得
  end

  # ログイン済みかどうか
  def logged_in?
    current_user.present? # current_user が存在すれば true
  end

  # ログイン必須
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインが必要です" # ログインページへ
    end
  end

  # 管理者のみアクセス可能
  def require_admin
    redirect_to root_path, alert: "権限がありません" unless current_user&.admin?
    # &. は nil 安全演算子（current_user が nil でもエラーにならない）
  end

  # 講師のみアクセス可能
  def require_instructor
    redirect_to root_path, alert: "権限がありません" unless current_user&.instructor?
  end

  # ログインユーザーのロールに応じたダッシュボードへリダイレクト
  def dashboard_path_by_role
    if current_user.admin?
      admin_root_path
    else
      users_path
    end
  end
end
