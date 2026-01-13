class TrainingSchedule < ApplicationRecord
  belongs_to :training
  belongs_to :room
  has_many :instructors
end
