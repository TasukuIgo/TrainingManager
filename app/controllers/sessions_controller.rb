class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    session[:user_id] = nil
  end

  def create
    auth_result = ExternalAuth::Authenticate.new(
      login_name: params[:name]
      password:   params[:password]
    ).call

    user = User.find_or_initialize_by(
      external_user_id: auth_result[:external_user_id] # 社内APIから一致するものを探すか新規作成するか
    )

    # 外部認証情報を同期
    user.name      = external_user[:name]       # 社内APIのnameをこのアプリのnameとする
    user.real_name = external_user[:real_name]  #社内APIのreal_nameをこのアプリのreal_nameとする
    
    user.role ||= "user" # なければ保存

    user.save!

    session[:user_id] = user.id
    redirect_to dashboard_path_by_role, notice: "ログイン成功"
  rescue ExternalAuth::Authenticate::AuthError
    flash.now[:alert] = "名前かパスワードが間違っています"
    render :new, status: :unprocessable_entity
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
