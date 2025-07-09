# app/models/coupon.rb
class Coupon < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true, numericality: { greater_than: 0 }

  # ✅ สร้างคูปองแบบปลอดภัย
  def self.safe_create(params)
    coupon = new(params)
    if coupon.save
      { success: true, coupon: coupon }
    else
      { success: false, errors: coupon.errors.full_messages }
    end
  end

  # ✅ ค้นหาคูปองแบบปลอดภัย
  def self.find_safe(id)
    coupon = find_by(id: id)
    if coupon
      { success: true, coupon: coupon }
    else
      { success: false, message: "ไม่พบคูปอง" }
    end
  end
end
