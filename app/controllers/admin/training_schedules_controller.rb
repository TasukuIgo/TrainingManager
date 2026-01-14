class Admin::TrainingSchedulesController < ApplicationController
  def new
    @training_schedule = TrainingSchedule.new
    @trainings   = Training.all
    @rooms       = Room.all
    @instructors = User.instructors
  end

  def create
    @training_schedule = TrainingSchedule.new(training_schedule_params)

    if @training_schedule.save
      # 講師が選ばれていれば紐づける（未定なら何もしない）
      if params[:instructor_user_id].present?
        Instructor.create!(
          training_schedule: @training_schedule,
          user_id: params[:instructor_user_id]
        )
      end

      redirect_to admin_training_schedules_path,
                  notice: "研修スケジュールを作成しました"
    else
      @trainings   = Training.all
      @rooms       = Room.all
      @instructors = User.instructors
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @schedules = TrainingSchedule
        .includes(:training)
        .map do |ts|
          {
            id: ts.id,
            title: ts.training&.title || "タイトル未設定",
            start: ts.date
          }
        end

    respond_to do |format|
      format.html
      format.json { render json: @schedules }
    end
  end

  def show
    @training_schedule = TrainingSchedule
        .includes(:training, :room, :users)
        .find(params[:id])
  end

  private

  def training_schedule_params
    params
      .require(:training_schedule)
      .permit(:training_id, :date, :room_id)
  end
end
