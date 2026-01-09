class Users::TrainingSchedulesController < ApplicationController
def index
  @schedules = TrainingSchedule.includes(:training)
end

  def show
  end
end
