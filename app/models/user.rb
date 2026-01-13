class User < ApplicationRecord
  has_many :instrucotrs
  has_many :training_schedules, through: :instructors
  
  has_secure_password

  # role カラムが 'instructor' のユーザーだけを返すスコープ
  scope :instructors, -> { where(role: 'instructor') }

  def admin?
    role == 'admin'
  end
end
