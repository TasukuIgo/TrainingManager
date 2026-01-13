class Admin::TrainingSchedulesController < ApplicationController
  
  def new
    @training_schedule = TrainingSchedule.new
    @trainings = Training.all
    @rooms = Room.all
    @instructors = User.instructors  # 講師一覧を取得する場合
  end

  def create
    @training_schedule = TrainingSchedule.new(training_schedule_params)
    if @training_schedule.save
      redirect_to admin_training_schedules_path, notice: "研修スケジュールを作成しました"
    else
      render :new
    end
  end

  def index
    @schedules = TrainingSchedule.includes(:training).all.map do |ts|
      {
        id: ts.id,
        title: ts.training&.title || "タイトル未設定",
        start: ts.date
      }
    end

    respond_to do |format|
      format.html # index.html.erb を返す
      format.json { render json: @schedules } # JSON を返す
    end
  end

  def show
    @training_schedule = TrainingSchedule.includes(:training, :room, instructors: :user).find(params[:id])
  end
end

def training_schedule_params
  params.require(:training_schedule).permit(:training_id, :date, :room_id)
end