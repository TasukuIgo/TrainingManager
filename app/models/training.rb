class Training < ApplicationRecord
  validates :title, :description, presence: true
  has_many :training_schedules
end
