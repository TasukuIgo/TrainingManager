class Users::TrainingSchedulesController < ApplicationController
  
  before_action :require_login

  def index
    # すべての研修スケジュール
    all_schedules = TrainingSchedule
                      .includes(:training)
                      .order(start_time: :asc)

    # プラン参加
    plan_ids = TrainingSchedule
                 .joins(plans: :plan_participations)
                 .where(plan_participations: { user_id: current_user.id })
                 .distinct
                 .pluck(:id)

    # 研修参加
    training_ids = TrainingSchedule
                     .joins(:training_participations)
                     .where(training_participations: { user_id: current_user.id })
                     .distinct
                     .pluck(:id)

    # 講師
    instructor_ids = current_user
                       .instructed_training_schedules
                       .pluck(:id)

    # role 付きでまとめる
    @calendar_schedules = all_schedules.map do |s|
      role =
        if plan_ids.include?(s.id)
          :plan_participant
        elsif training_ids.include?(s.id)
          :training_participant
        elsif instructor_ids.include?(s.id)
          :instructor
        else
          :unassigned
        end

      [s, role]
    end
  end

  def show
    @training_schedule = TrainingSchedule.find(params[:id])
    @participants = @training_schedule.participants
  end
end
