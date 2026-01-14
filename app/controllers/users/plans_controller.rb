class Users::PlansController < ApplicationController
def index
  @plans = current_user.plans.includes(training_schedules: :training)
end

  def show
  end
end
