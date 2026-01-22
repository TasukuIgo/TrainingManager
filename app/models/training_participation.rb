class TrainingParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :training_schedule

  def display_status
    training_schedule.start_time.future? ? "予定" : "参加済み"
  end
end
