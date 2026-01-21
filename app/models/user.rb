class User < ApplicationRecord
  # -----------------------------
  # ロール判定
  # -----------------------------
  ROLES = %w[admin instructor user guest].freeze
  validates :role, inclusion: { in: ROLES }

  def admin?; role == "admin"; end
  def instructor?; role == "instructor"; end
  def regular_user?; role == "user" || role.blank?; end

  # -----------------------------
  # 外部認証
  # -----------------------------
  validates :external_user_id, presence: true, uniqueness: true

  # -----------------------------
  # 講師として担当している研修
  # -----------------------------
  has_many :instructor_assignments, class_name: "Instructor"
  has_many :instructed_training_schedules,
           through: :instructor_assignments,
           source: :training_schedule

  # -----------------------------
  # 受講者として参加している研修
  # -----------------------------
  has_many :training_participations, dependent: :destroy
  has_many :participated_training_schedules,
           through: :training_participations,
           source: :training_schedule

  # -----------------------------
  # プラン
  # -----------------------------
  has_many :plan_participations, dependent: :destroy
  has_many :plans, through: :plan_participations

  # -----------------------------
  # スコープ
  # -----------------------------
  scope :instructors, -> { where(role: "instructor") }
end
