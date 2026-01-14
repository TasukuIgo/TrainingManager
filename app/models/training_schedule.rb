class TrainingSchedule < ApplicationRecord
  belongs_to :training
  belongs_to :room
  belongs_to :instructor, class_name: "User", optional: true 
  has_many :instructors
  has_many :users, through: :instructors
  has_many :created_plans, dependent: :destroy
  has_many :plans, through: :created_plans
end
