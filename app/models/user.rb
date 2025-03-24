class User < ApplicationRecord
  has_secure_password
  has_one :session
  has_many :messages
  has_many :rooms, through: :messages

  validates :name, :email, :password, presence: true, length: { maximum: 50 }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
