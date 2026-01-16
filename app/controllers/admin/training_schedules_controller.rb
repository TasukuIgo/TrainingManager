class Admin::TrainingSchedulesController < ApplicationController
  layout "fullcalendar", only: [:index]

  before_action :load_master_data, only: [:new, :create, :edit, :update]

  def new
    @training_schedule = TrainingSchedule.new
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
    @training_schedule = TrainingSchedule
      .includes(:users)
      .find(params[:id])
  end

  def update
    @training_schedule = TrainingSchedule
      .includes(:users)
      .find(params[:id])

    if @training_schedule.update(training_schedule_params)
      if params[:training_schedule][:instructor_id].present?
        @training_schedule.instructors.destroy_all
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:training_schedule][:instructor_id]
        )
      else
        @training_schedule.instructors.destroy_all
      end

      redirect_to admin_training_schedules_path,
                  notice: "研修スケジュールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @training_schedules = TrainingSchedule
      .includes(:training)
      .map do |ts|
        {
          id: ts.id,
          title: ts.training&.title || "タイトル未設定",
          start: ts.start_time,
          end: ts.end_time
        }
      end

    respond_to do |format|
      format.html
      format.json { render json: @training_schedules }
    end
  end

  def show
    @training_schedule = TrainingSchedule
      .includes(:training, :room, :users)
      .find(params[:id])
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
  end

  def training_schedule_params
    start_date = params[:training_schedule].delete(:start_time_date)
    start_time = params[:training_schedule].delete(:start_time_time)
    end_date   = params[:training_schedule].delete(:end_time_date)
    end_time   = params[:training_schedule].delete(:end_time_time)

    params[:training_schedule][:start_time] = "#{start_date} #{start_time}" if start_date && start_time
    params[:training_schedule][:end_time]   = "#{end_date} #{end_time}"     if end_date && end_time

    params.require(:training_schedule)
          .permit(:training_id, :start_time, :end_time, :room_id)
  end
end
