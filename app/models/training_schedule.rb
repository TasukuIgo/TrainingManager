class TrainingSchedule < ApplicationRecord
  belongs_to :training
  belongs_to :room
  belongs_to :instructor, class_name: "User", optional: true 
end
