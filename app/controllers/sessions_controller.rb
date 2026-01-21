class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    session[:user_id] = nil
  end

  def create
    binding.pry
    require 'net/http'
    require 'uri'
    require 'json'

    # Docker Compose 内の Fundely コンテナに向ける
    uri = URI("http://host.docker.internal:11000/api/users/authenticate")
    req = Net::HTTP::Post.new(uri)
    req["X-Api-Key"] = "testkey"  # ←直接書く
    req["Content-Type"] = "application/json"
    req.body = { username: params[:login_name], password: params[:password] }.to_json
    binding.pry

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    if res.is_a?(Net::HTTPSuccess)
      user_data = JSON.parse(res.body)

      user = User.find_or_initialize_by(id: user_data["id"])
      user.external_user_id = user_data["id"]
      user.real_name = user_data["name"]
      user.name      = user_data["username"]
      user.role      = user_data["role"]
      user.save!

      session[:user_id] = user.id
      redirect_to dashboard_path_by_role, notice: "ログイン成功"
    else
      flash.now[:alert] = "ログイン失敗"
      render :new
    end

  rescue StandardError => e
    Rails.logger.error("API ERROR: #{e.message}")
    flash.now[:alert] = "API接続に失敗しました"
    render :new
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
