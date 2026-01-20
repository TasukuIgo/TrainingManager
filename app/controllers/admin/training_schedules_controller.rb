class Admin::TrainingSchedulesController < ApplicationController
  
  before_action :require_login
  before_action :load_master_data, only: [:new, :create, :edit, :update]


  def new
    @training_schedule = TrainingSchedule.new
  end

  def index
    @training_schedules = TrainingSchedule.includes(:training).order(start_time: :asc)

    @calendar_schedules = @training_schedules.map do |schedule|
      [schedule, :other]
    end
  end




  def show
    @training_schedule = TrainingSchedule
    .includes(:training, :room, :participants)
    .find(params[:id])

    # 参加者一覧を取得
    @participants = @training_schedule.participants
    @instructors  = @training_schedule.instructors
  end

  def create
    @training_schedule = TrainingSchedule.new(training_schedule_params)

    if @training_schedule.save
      # --- 講師登録 ---
      if params[:training_schedule][:instructor_id].present?
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
      end

      # --- 参加者登録 ---
      if params[:training_schedule][:participant_ids].present?
        params[:training_schedule][:participant_ids].reject(&:blank?).each do |uid|
          TrainingParticipation.create!(
            training_schedule: @training_schedule,
            user_id: uid,
            status: "confirmed" # 必要に応じて
          )
        end
      end

      redirect_to admin_training_schedules_path,
                  notice: "研修スケジュールを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @training_schedule = TrainingSchedule.find(params[:id])

    # 参加者一覧（複数選択用）
    @participants = @training_schedule.participants
    # 講師だけ取り出す場合
    @instructors = User.where(role: "instructor")
    # フォーム用に全ユーザーを取得
    @users = User.all
  end

  def update
    @training_schedule = TrainingSchedule.find(params[:id])

    if @training_schedule.update(training_schedule_params)
      # --- 講師の更新 ---
      @training_schedule.instructors.destroy_all
      if params[:training_schedule][:instructor_id].present?
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
      end

      # --- 参加者の更新 ---
      @training_schedule.training_participations.destroy_all
      if params[:training_schedule][:participant_ids].present?
        params[:training_schedule][:participant_ids].reject(&:blank?).each do |uid|
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


  def destroy
    schedule = TrainingSchedule.find(params[:id])
    schedule.destroy
    redirect_to admin_training_schedules_path,
                notice: "スケジュールを削除しました"
  end



  
  private

  def load_master_data
    @trainings   = Training.all
    @rooms       = Room.all
    @instructors = User.instructors
    @users = User.all
  end

  def training_schedule_params
    start_date = params[:training_schedule].delete(:start_time_date)
    start_time = params[:training_schedule].delete(:start_time_time)
    end_date   = params[:training_schedule].delete(:end_time_date)
    end_time   = params[:training_schedule].delete(:end_time_time)

    params[:training_schedule][:start_time] = "#{start_date} #{start_time}" if start_date && start_time
    params[:training_schedule][:end_time]   = "#{end_date} #{end_time}"     if end_date && end_time

      params.require(:training_schedule)
        .permit(
          :training_id,
          :start_time,
          :end_time,
          :room_id,
          participant_ids: []
        )
  end
end
