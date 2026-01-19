class Admin::TrainingSchedulesController < ApplicationController
  
  before_action :require_login
  before_action :load_master_data, only: [:new, :create, :edit, :update]


  def new
    @training_schedule = TrainingSchedule.new
  end

  def index
    @training_schedules = TrainingSchedule.includes(:training).all

    respond_to do |format|
      format.html
      format.json { render json: @training_schedules.as_json(
        include: { training: { only: :title } },
        only: [:id, :start_time, :end_time]
      ) }
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
      if params[:training_schedule][:instructor_id].present?
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
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
    @instructors = @training_schedule.instructors

    # フォーム用に全ユーザーを取得
    @users = User.all
  end

  def update
    @training_schedule = TrainingSchedule.find(params[:id]) # includes(:users) は削除

    if @training_schedule.update(training_schedule_params)
      # フォームから送られた講師IDをInstructorテーブルで更新
      if params[:training_schedule][:instructor_id].present?
        # 既存の講師関連を削除して新規作成
        @training_schedule.instructors.destroy_all
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
      else
        # 講師未選択なら関連を削除
        @training_schedule.instructors.destroy_all
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
