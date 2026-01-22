class Users::PlansController < ApplicationController
  before_action :require_login

  # 参加者・講師として関わる研修をまとめて取得
  def index
    # すべての研修スケジュール
    all_schedules = TrainingSchedule.includes(:training).all

    # Plan参加
    plan_schedules = TrainingSchedule
                      .joins(plans: :plan_participations)
                      .where(plan_participations: { user_id: current_user.id })
                      .distinct

    # TrainingParticipation参加
    training_schedules = current_user.training_participations
                                     .map(&:training_schedule)
                                     .uniq

    # 講師担当
    instructor_schedules = current_user.instructed_training_schedules

    # それぞれをハッシュ化して優先度を付与
    @schedules_with_roles = all_schedules.map do |s|
      role =
        if plan_schedules.include?(s)
          :plan_participant
        elsif training_schedules.include?(s)
          :training_participant
        elsif instructor_schedules.include?(s)
          :instructor
        else
          nil
        end

      [s, role]
    end
  end


  # Plan の詳細表示
  def show
    @plan = Plan.find(params[:id])
    @training_schedule = @plan.training_schedules.first
  end
end