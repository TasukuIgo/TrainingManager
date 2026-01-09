class Instructor < ApplicationRecord
  belongs_to :user
  belongs_to :training_schedule
end
