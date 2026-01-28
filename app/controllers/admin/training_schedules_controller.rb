class Admin::TrainingSchedulesController < ApplicationController
  # ログインしていないとアクセス不可
  before_action :require_login
  # 新規作成・編集フォームで使うマスタデータを読み込む
  before_action :load_master_data, only: [:new, :create, :edit, :update]

  # 新規作成フォーム
  def new
    @training_schedule = TrainingSchedule.new
  end

  # 一覧表示
  def index
    # 研修スケジュールを研修情報込みで取得
    @training_schedules = TrainingSchedule.includes(:training).order(start_time: :asc)

    # カレンダー用データ
    @calendar_schedules = @training_schedules.map do |schedule|
      [schedule, :other]
    end
  end

  # 詳細表示
  def show
    @training_schedule = TrainingSchedule
      .includes(:training, :room, :participants) # N+1対策
      .find(params[:id]) # idで検索

    # 参加者一覧と講師一覧を取得
    @participants = @training_schedule.participants
    @instructors  = @training_schedule.instructors
  end

  # 作成処理
  def create
    @training_schedule = TrainingSchedule.new(training_schedule_params)

    if @training_schedule.save
      # 講師登録
      if params[:training_schedule][:instructor_id].present?
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
      end

      # 参加者登録
      if params[:training_schedule][:participant_ids].present?
        params[:training_schedule][:participant_ids]
          .reject(&:blank?) # 空欄を除く
          .each do |uid|
            TrainingParticipation.create!(
              training_schedule: @training_schedule,
              user_id: uid,
              status: "confirmed" # 初期ステータス
            )
          end
      end

      redirect_to admin_training_schedules_path,
                  notice: "研修スケジュールを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム
  def edit
    @training_schedule = TrainingSchedule.find(params[:id])

    # フォームで使うデータ
    @participants = @training_schedule.participants   # 参加者一覧
    @instructors  = User.where(role: "instructor")   # 講師一覧
    @users        = User.all                         # 全ユーザー（参加者選択用）
  end

  # 更新処理
  def update
    @training_schedule = TrainingSchedule.find(params[:id])

    if @training_schedule.update(training_schedule_params)
      # 講師の更新
      @training_schedule.instructors.destroy_all # 既存講師を削除
      if params[:training_schedule][:instructor_id].present?
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
      end

      # 参加者の更新
      @training_schedule.training_participations.destroy_all # 既存参加者を削除
      if params[:training_schedule][:participant_ids].present?
        params[:training_schedule][:participant_ids]
          .reject(&:blank?)
          .each do |uid|
            TrainingParticipation.create!(
              training_schedule: @training_schedule,
              user_id: uid,
              status: "confirmed"
            )
          end
      end

      redirect_to admin_training_schedules_path,
                  notice: "研修スケジュールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    schedule = TrainingSchedule.find(params[:id])
    schedule.destroy
    redirect_to admin_training_schedules_path,
                notice: "スケジュールを削除しました"
  end

  private

  # 新規・編集フォーム用：マスタデータを読み込む
  def load_master_data
    @trainings   = Training.all
    @rooms       = Room.all
    @instructors = User.instructors
    @users       = User.all
  end

  # フォームから送られたパラメータを整形
  def training_schedule_params
    # 日付と時間を結合して datetime に変換
    start_date = params[:training_schedule].delete(:start_time_date)
    start_time = params[:training_schedule].delete(:start_time_time)
    end_date   = params[:training_schedule].delete(:end_time_date)
    end_time   = params[:training_schedule].delete(:end_time_time)

    # date+timeをstart_time, end_time にセット
    params[:training_schedule][:start_time] = "#{start_date} #{start_time}" if start_date && start_time
    params[:training_schedule][:end_time]   = "#{end_date} #{end_time}"     if end_date && end_time

    # 許可されたパラメータだけ受け取る
    params.require(:training_schedule)
      .permit(
        :training_id,
        :start_time,
        :end_time,
        :room_id,
        participant_ids: [] # 配列で受け取る
      )
  end
end
