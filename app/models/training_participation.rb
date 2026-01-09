class TrainingParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :training_schedule
end
