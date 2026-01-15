class User < ApplicationRecord

  has_secure_password
  
  has_many :instrucotrs
  has_many :training_schedules, through: :instructors
  has_many :plan_participations, dependent: :destroy
  has_many :plans, through: :plan_participations


  # role カラムが 'instructor' のユーザーだけを返すスコープ
  scope :instructors, -> { where(role: 'instructor') }

  def admin?
    role == 'admin'
  end
end
