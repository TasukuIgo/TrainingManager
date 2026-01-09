class SessionsController < ApplicationController
  def new
  end

  def create
    # 仮ログイン
    session[:role] = params[:role] # "user" or "admin"

    if session[:role] == "admin"
      redirect_to admin_root_path
    else
      redirect_to users_root_path
    end
  end
end