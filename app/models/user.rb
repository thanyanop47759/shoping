class User < ApplicationRecord
  has_secure_password

  before_create :generate_auth_token

  has_many :products
  has_one :cart
  has_many :orders

  validates :email, presence: true, uniqueness: true

  def generate_auth_token
    self.auth_token ||= SecureRandom.hex(20)
  end

  def admin?
    role == "admin"
  end

  # สร้าง token ใหม่และบันทึก
  def regenerate_auth_token!
    update(auth_token: SecureRandom.hex(20))
  end

  # ลบ token (logout)
  def clear_auth_token!
    update(auth_token: nil)
  end

  # หา user จาก Authorization header
  def self.find_by_token(auth_header)
    return nil if auth_header.blank?

    token = auth_header.split(" ").last
    Rails.logger.info("[User.find_by_token] Token extracted: #{token.inspect}")

    user = find_by(auth_token: token)
    Rails.logger.info("[User.find_by_token] User found: #{user&.id || "nil"}")

    user
  end
  def visible_products_for(requester)
  return products if requester&.admin? || requester == self
  nil # ไม่มีสิทธิ์
end

def self.find_products_for_admin_or_user(requester, user_id_param = nil)
  if requester.admin?
    if user_id_param
      user = find_by(id: user_id_param)
      return { success: false, message: "ไม่พบผู้ใช้" } unless user

      { success: true, products: user.products }
    else
      { success: true, products: Product.all }
    end
  else
    if user_id_param && user_id_param.to_i != requester.id
      { success: false, message: "คุณไม่มีสิทธิ์เข้าถึงสินค้าของผู้อื่น" }
    else
      { success: true, products: requester.products }
    end
  end
end
end
