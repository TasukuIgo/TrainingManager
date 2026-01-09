class ApplicationController < ActionController::Base
  private

  def require_login
    redirect_to login_path unless session[:role]
  end
end