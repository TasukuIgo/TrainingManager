class Admin::TrainingSchedulesController < ApplicationController
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