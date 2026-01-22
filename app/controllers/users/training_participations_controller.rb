class Users::TrainingParticipationsController < ApplicationController
  
  before_action :require_login

  def index
    @training_participations =
      current_user.training_participations
                  .includes(training_schedule: [:training, :room, :participants])
                  .order("training_schedules.start_time DESC")
  end

  def show
    @training_participation =
      current_user.training_participations.find(params[:id])
    @training_schedule = @training_participation.training_schedule
  end
end
