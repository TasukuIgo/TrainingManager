module ApplicationHelper
 def dashboard_path_by_role
    if current_user.admin?
      admin_dashboard_path
    else
      dashboard_path
    end
  end
end
