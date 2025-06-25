class User < ApplicationRecord
  has_secure_password

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token ||= SecureRandom.hex(20)
  end

  def admin?
    role == "admin"
  end

  has_many :products
  has_one :cart
  has_many :orders

  validates :email, presence: true, uniqueness: true
end
