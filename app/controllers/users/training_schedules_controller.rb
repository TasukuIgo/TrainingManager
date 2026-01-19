class Users::TrainingSchedulesController < ApplicationController
  
  before_action :require_login

  def index
    @training_schedules = TrainingSchedule
                            .includes(:training)
                            .order(start_time: :asc)
  end

  def show
    @training_schedule = TrainingSchedule.find(params[:id])
    @participants = @training_schedule.participants
  end
end
