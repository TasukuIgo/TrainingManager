class User < ApplicationRecord
  has_secure_password

  # 講師として担当している研修
  has_many :instructed_training_schedules,
           class_name: "TrainingSchedule",
           foreign_key: :instructor_id,
           dependent: :nullify

  # 受講者として参加している研修
  has_many :training_participations, dependent: :destroy
  has_many :participated_training_schedules,
           through: :training_participations,
           source: :training_schedule

  # プラン
  has_many :plan_participations, dependent: :destroy
  has_many :plans, through: :plan_participations

  # role スコープ
  scope :instructors, -> { where(role: "instructor") }

  def admin?
    role == "admin"
  end
end
