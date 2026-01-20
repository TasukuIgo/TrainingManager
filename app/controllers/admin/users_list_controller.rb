module Admin
  class UsersListController < ApplicationController
    before_action :require_login
    before_action :require_admin  # 管理者以外はアクセス不可

    def index
      @users = User.order(:id)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_list_index_path, notice: "ユーザーのロールを更新しました"
      else
        flash.now[:alert] = "更新に失敗しました"
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:role)
    end

    def require_admin
      redirect_to root_path, alert: "権限がありません" unless current_user&.admin?
    end
  end
end
