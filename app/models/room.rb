class Room < ApplicationRecord
  has_many :users, through: :messages
  validates :name, presence: true
end
