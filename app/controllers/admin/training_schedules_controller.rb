# app/controllers/admin/training_schedules_controller.rb
class Admin::TrainingSchedulesController < ApplicationController
  def index
    @training_schedules =
      TrainingSchedule
        .includes(:training)
        .order(:start_date)
  end
end
