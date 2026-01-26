class Users::TrainingSchedulesController < ApplicationController
  # ログイン必須
  before_action :require_login
  # show の対象研修スケジュールを取得
  before_action :set_training_schedule, only: [:show]

  # 研修スケジュール一覧（カレンダー用）
  def index
    # すべての研修スケジュール（研修情報込み）
    all_schedules = TrainingSchedule.includes(:training).order(start_time: :asc)

    # --- プラン参加 ---
    plan_ids = TrainingSchedule
                 .joins(plans: :plan_participations)        # Plan -> PlanParticipation を結合
                 .where(plan_participations: { user_id: current_user.id }) # 自分の参加
                 .distinct                                 # 重複を除く
                 .pluck(:id)                               # id だけ取り出す

    # --- 研修参加 ---
    training_ids = TrainingSchedule
                     .joins(:training_participations)      # TrainingParticipation を結合
                     .where(training_participations: { user_id: current_user.id })
                     .distinct
                     .pluck(:id)

    # --- 講師担当 ---
    instructor_ids = current_user.instructed_training_schedules.pluck(:id)

    # 各スケジュールに「役割」を付与
    @calendar_schedules = all_schedules.map do |s|
      role =
        if plan_ids.include?(s.id)
          :plan_participant          # Plan参加者
        elsif training_ids.include?(s.id)
          :training_participant      # 研修参加者
        elsif instructor_ids.include?(s.id)
          :instructor                # 講師
        else
          :unassigned                # 関わりなし
        end

      [s, role]  # スケジュールと役割をペアにしてビューで使いやすく
    end
  end

  # 研修スケジュール詳細
  def show
    # before_action で @training_schedule を取得済み
    @participants = @training_schedule.participants   # 参加者一覧
    @training = @training_schedule.training          # 研修情報
    @materials = @training&.materials || []          # 研修資料（nilなら空配列）
  end

  private

  # show の対象スケジュールを取得
  def set_training_schedule
    @training_schedule = TrainingSchedule.find(params[:id])
  end
end
