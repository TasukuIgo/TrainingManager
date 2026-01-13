class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    session[:user_id] = nil
  end

  def create
    user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      # ロール別にダッシュボードへリダイレクト
      redirect_to dashboard_path_by_role, notice: "ログイン成功"
    else
      flash.now[:alert] = "名前かパスワードが間違っています"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "ログアウトしました"
  end


  private

  #ロールによる遷移先分岐
  def dashboard_path_by_role
    if current_user.admin?
      admin_root_path   # 管理者用のトップページ
    else
      users_root_path   # 一般ユーザー用のトップページ
    end
  end

end
