class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    session[:user_id] = nil
  end

  def create
    auth_result = ExternalAuth::Authenticate.new(
      login_name: params[:login_name],
      password:   params[:password]
    ).call

    user = User.find_or_initialize_by(external_user_id: auth_result[:external_user_id])
    user.name      = auth_result[:login_name]
    user.real_name = auth_result[:real_name]
    user.role    ||= "user"
    user.save!

    session[:user_id] = user.id
    redirect_to dashboard_path_by_role, notice: "ログイン成功"

  rescue ExternalAuth::Authenticate::AuthError
    flash.now[:alert] = "名前かパスワードが間違っています"
    render :new, status: :unprocessable_entity
  rescue ExternalAuth::Authenticate::ConnectionError,       ExternalAuth::Authenticate::TimeoutError => e
  Rails.logger.error "ExternalAuth API Error: #{e.message}"
   flash.now[:alert] = "現在ログインできません。時間を置いて再度お試しください。"
    render :new, status: :service_unavailable
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
