class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    session[:user_id] = nil
  end

  def create
    require 'net/http'
    require 'uri'
    require 'json'

    # 環境変数から API エンドポイントとキーを取得
    api_endpoint = ENV.fetch("FD_API_ENDPOINT")
    api_key      = ENV.fetch("FD_API_KEY")

    # URI 作成
    uri = URI("#{api_endpoint}/users/authenticate")

    # POST リクエスト作成
    req = Net::HTTP::Post.new(uri)
    req["X-Api-Key"] = api_key
    req["Content-Type"] = "application/json"

    # リクエストボディ設定
    req.body = {
      username: params[:login_name],
      password: params[:password]
    }.to_json

    # リクエスト送信
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    if res.is_a?(Net::HTTPSuccess)
      user_data = JSON.parse(res.body)

      # 外部IDでユーザー取得 or 作成
      user = User.find_or_initialize_by(external_user_id: user_data["id"])
      user.real_name = user_data["name"]
      user.name      = user_data["username"]
      user.role ||= "user"
      user.save!

      session[:user_id] = user.id
      redirect_to dashboard_path_by_role, notice: "ログイン成功"
    else
      flash.now[:alert] = "ログイン失敗"
      render :new, status: :unauthorized
    end

  rescue StandardError => e
    Rails.logger.error("API ERROR: #{e.message}")
    flash.now[:alert] = "API接続に失敗しました"
    render :new, status: :internal_server_error
  end

  def destroy
    session[:user_id] = nil
    redirect_to dashboard_path_by_role, notice: "ログアウトしました"
  end

  private

  def dashboard_path_by_role
    current_user.admin? ? admin_root_path : users_root_path
  end
end
