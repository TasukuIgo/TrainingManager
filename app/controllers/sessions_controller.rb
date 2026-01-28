class SessionsController < ApplicationController
  # ログインしていない状態でのみ new と create にアクセス可能
  skip_before_action :require_login, only: %i[new create]

  # ログインフォーム
  def new
    session[:user_id] = nil # 既存のログイン情報をクリア
  end

  # ログイン処理
  def create
    require 'net/http'
    require 'uri'
    require 'json'

    # 環境変数からAPIの情報を取得
    api_endpoint = ENV.fetch("FD_API_ENDPOINT")
    api_key      = ENV.fetch("FD_API_KEY")

    # 認証用 URI を作成
    uri = URI("#{api_endpoint}/users/authenticate")

    # POST リクエスト作成
    req = Net::HTTP::Post.new(uri)
    req["X-Api-Key"] = api_key            # APIキーをセット
    req["Content-Type"] = "application/json"

    # 送信する JSON データ
    req.body = {
      username: params[:login_name],
      password: params[:password]
    }.to_json

    # リクエスト送信
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end

    if res.is_a?(Net::HTTPSuccess)
      user_data = JSON.parse(res.body)

      # 外部ユーザーIDで既存ユーザーを取得、なければ新規作成
      user = User.find_or_initialize_by(external_user_id: user_data["id"])
      user.real_name = user_data["name"]
      user.name      = user_data["username"]
      user.role ||= "user"  
      # 初回ログイン時は必ずUserロールの割り当てになるため必要に応じてAdminアカウントから変更

      user.save!

      # セッションにユーザーIDを保存（ログイン状態保持）
      session[:user_id] = user.id
      redirect_to dashboard_path_by_role, notice: "ログイン成功"
    else
      flash.now[:alert] = "ログイン失敗"
      render :new, status: :unauthorized
    end

  # APIエラーやネットワークエラーを捕捉
  rescue StandardError => e
    Rails.logger.error("API ERROR: #{e.message}")
    flash.now[:alert] = "API接続に失敗しました"
    render :new, status: :internal_server_error
  end

  # ログアウト処理
  def destroy
    session[:user_id] = nil
    redirect_to dashboard_path_by_role, notice: "ログアウトしました"
  end

  private

  # ユーザーのロールによってダッシュボードにリダイレクト
  def dashboard_path_by_role
    current_user.admin? ? admin_root_path : users_root_path
  end
end
