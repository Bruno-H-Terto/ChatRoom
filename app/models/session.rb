class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_token
  before_create :expired_at_session

  def encode_token
    JWT.encode(self.token, Rails.application.credentials.secret_key_base)
  end

  private
  def expired_at_session
    self.expired_at = 30.minutes.from_now
  end

  def generate_token
    self.token = SecureRandom.alphanumeric(12)
  end
end
