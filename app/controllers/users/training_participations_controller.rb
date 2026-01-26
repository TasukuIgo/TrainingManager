class Users::TrainingParticipationsController < ApplicationController
  # ログイン必須
  before_action :require_login

  # 参加中の研修一覧
  def index
    # current_user が参加している TrainingParticipation を取得
    # includes で関連するテーブルもまとめて読み込む（N+1問題対策）
    @training_participations =
      current_user.training_participations
                  .includes(training_schedule: [:training, :room, :participants])
                  .order("training_schedules.start_time DESC") # 開始日時の降順
  end

  # 研修参加詳細
  def show
    # 自分の参加データのみ取得（他人の参加データは見れない）
    @training_participation =
      current_user.training_participations.find(params[:id])
    
    # 参加している研修スケジュールを取得
    @training_schedule = @training_participation.training_schedule
  end
end
