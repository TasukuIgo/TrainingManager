module Admin
  class UsersListController < ApplicationController
    # ログイン必須
    before_action :require_login
    # 管理者のみアクセス可能
    before_action :require_admin  

    # 一覧表示
    def index
      # 全ユーザーをID順で取得
      @users = User.order(:id)
    end

    # 編集フォーム
    def edit
      # 更新対象のユーザーを取得
      @user = User.find(params[:id])
    end

    # 更新処理
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_list_index_path, notice: "ユーザーのロールを更新しました"
      else
        # 更新できなかった場合
        flash.now[:alert] = "更新に失敗しました"
        render :edit
      end
    end

    private

    # 許可されたパラメータだけ受け取る
    def user_params
      params.require(:user).permit(:role)
    end

    # 管理者でなければトップページにリダイレクト
    def require_admin
      redirect_to root_path, alert: "権限がありません" unless current_user&.admin?
      # current_user&.admin? … current_user が存在しない場合でも安全に判定
    end
  end
end
