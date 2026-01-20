class TrainingSchedule < ApplicationRecord
  belongs_to :training
  belongs_to :room, optional: true

  # -----------------------------
  # 参加者
  # -----------------------------
  has_many :training_participations, dependent: :destroy
  has_many :participants,
           through: :training_participations,
           source: :user

  # -----------------------------
  # プラン
  # -----------------------------
  has_many :created_plans, dependent: :destroy
  has_many :plans, through: :created_plans

  # -----------------------------
  # 講師（Instructor テーブル経由）
  # -----------------------------
  has_many :instructors, dependent: :destroy
  has_many :users_as_instructor, through: :instructors, source: :user

  # -----------------------------
  # バリデーション
  # -----------------------------
  validates :start_time, presence: true
  validates :end_time, presence: true
end
