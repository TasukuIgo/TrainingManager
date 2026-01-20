class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  # ログインフォーム
  def new
    session[:user_id] = nil
  end

  # Fundely API対応ログイン
  def create
    login_name = params[:login_name]
    password   = params[:password]  # UI上は残すが APIでは使わない

    # login_name を user_name に流用、user_id は必要に応じて変換
    user_name = login_name
    user_id   = fetch_user_id_from_name(login_name)

    # Fundely APIでユーザ情報を取得
    user_info = LoginFetcher.fetch_user_info(user_id: user_id, user_name: user_name)

    if user_info
      # Userを作成または更新
      user = User.find_or_initialize_by(fundely_user_id: user_info[:user_id])
      user.name      = user_info[:user_name]
      user.real_name = user_info[:real_name] # API返り値
      user.role      ||= "user"
      user.save!

      # セッションにセット
      session[:user_id] = user.id
      redirect_to dashboard_path_by_role, notice: "ログイン成功"
    else
      flash.now[:alert] = "名前かIDが間違っています"
      render :new, status: :unprocessable_entity
    end

  rescue StandardError => e
    Rails.logger.error "Fundely API Error: #{e.class} #{e.message}"
    flash.now[:alert] = "現在ログインできません。時間を置いて再度お試しください。"
    render :new, status: :service_unavailable
  end

  # ログアウト
  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "ログアウトしました"
  end

  private

  # login_name → user_id 変換用（必要に応じて実装）
  def fetch_user_id_from_name(login_name)
    # もし login_name がそのまま user_id になるなら login_name を返すだけでもOK
    login_name
  end

  # ロールによるダッシュボード分岐
  def dashboard_path_by_role
    if current_user.admin?
      admin_root_path   # 管理者用トップ
    else
      users_root_path   # 一般ユーザ用トップ
    end
  end
end
