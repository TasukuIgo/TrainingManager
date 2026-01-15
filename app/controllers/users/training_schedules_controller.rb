class Users::TrainingSchedulesController < ApplicationController
  before_action :require_login

  def index
    # 参加予定研修の一覧をカレンダー用に取得
    @schedules = TrainingSchedule
                   .joins(plan: :plan_participations)
                   .where(plan_participations: { user_id: current_user.id })
                   .distinct
  end

  def show
    @schedule = TrainingSchedule.find(params[:id])
  end
end