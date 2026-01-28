class Users::PlansController < ApplicationController
  # ログイン必須
  before_action :require_login

  # 参加者・講師として関わる研修をまとめて取得
  def index
    # すべての研修スケジュール（研修情報込み）
    all_schedules = TrainingSchedule.includes(:training).all

    # Planに参加している研修スケジュール
    plan_schedules = TrainingSchedule
                      .joins(plans: :plan_participations)
                      .where(plan_participations: { user_id: current_user.id })
                      .distinct  # 重複を除く

    # TrainingParticipationに参加している研修スケジュール
    training_schedules = current_user.training_participations
                                     .map(&:training_schedule) # 配列に変換
                                     .uniq                      # 重複除去

    # 講師担当の研修スケジュール
    instructor_schedules = current_user.instructed_training_schedules

    # 各スケジュールに「自分の役割」を付与
    @schedules_with_roles = all_schedules.map do |s|
      role =
        if plan_schedules.include?(s)
          :plan_participant          # Plan参加者
        elsif training_schedules.include?(s)
          :training_participant      # 研修参加者
        elsif instructor_schedules.include?(s)
          :instructor                # 講師
        else
          nil                        # 関わりなし
        end

      [s, role]  # 配列にしてビューで使いやすく
    end
  end

  # Plan の詳細表示
  def show
    @plan = Plan.find(params[:id])                     # Plan を取得
    @training_schedule = @plan.training_schedules.first # 関連スケジュールの最初の1件
  end
end
