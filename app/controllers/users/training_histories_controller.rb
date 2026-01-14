class Users::TrainingHistoriesController < ApplicationController
def index
  @histories = current_user.training_participations.includes(training_schedule: :training)
end

end
