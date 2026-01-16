class TrainingSchedule < ApplicationRecord
  belongs_to :training
  belongs_to :room, optional: true

  # 参加者
  has_many :training_participations, dependent: :destroy
  has_many :participants,
           through: :training_participations,
           source: :user

  # プラン
  has_many :created_plans, dependent: :destroy
  has_many :plans, through: :created_plans

  validates :start_time, presence: true
  validates :end_time, presence: true

  # 講師（参加者の中から role で判定）
  def instructors
    participants.where(role: "instructor")
  end
end
