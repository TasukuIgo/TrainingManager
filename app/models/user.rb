class User < ApplicationRecord
  has_many :instrucotrs
  has_secure_password

  def admin?
    role == 'admin'
  end
end
