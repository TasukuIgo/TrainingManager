class Users::PlansController < ApplicationController
  def index
    # current_user が参加している Plan に紐づく TrainingSchedule を取得
    @schedules = TrainingSchedule
               .distinct
               .joins(created_plans: { plan: :plan_participations })
               .where(plan_participations: { user_id: current_user.id })
               .includes(:training)

  end
  
  def show
    @plan = Plan.find(params[:id])
    @schedule = @plan.training_schedules.first 
  end

end
