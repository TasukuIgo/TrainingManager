module ApplicationHelper
  def dashboard_path_by_role
    if current_user.admin?
      admin_root_path   # ← admin_dashboard_path → admin_root_path に変更
    else
      users_root_path   # ← dashboard_path → users_root_path に変更
    end
  end
end
