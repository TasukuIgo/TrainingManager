class CreatedPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :training_schedule
end
