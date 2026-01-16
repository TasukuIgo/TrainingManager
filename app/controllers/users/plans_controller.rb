class Users::PlansController < ApplicationController
  # current_user が参加している Plan に紐づく TrainingSchedule を取得
  def index
    @my_schedules = TrainingSchedule
                      .distinct
                      .joins(created_plans: { plan: :plan_participations })
                      .where(plan_participations: { user_id: current_user.id })
                      .includes(:training, :plans)
  end
  
  def show
    @plan = Plan.find(params[:id])
    @training_schedule = @plan.training_schedules.first 
  end

end
