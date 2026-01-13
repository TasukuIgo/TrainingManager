class User < ApplicationRecord
  has_many :instrucotrs
  has_secure_password

  # role カラムが 'instructor' のユーザーだけを返すスコープ
  scope :instructors, -> { where(role: 'instructor') }

  def admin?
    role == 'admin'
  end
end
