class Training < ApplicationRecord
  validates :title, :description, presence: true
end
