# app/models/user_log.rb
class UserLog < ApplicationRecord
  belongs_to :user

  # ✅ โหลด log 100 รายการล่าสุดพร้อมข้อมูลผู้ใช้
  def self.recent_with_user(limit_count = 100)
    includes(:user).order(created_at: :desc).limit(limit_count)
  end

  # ✅ คืนค่ารูปแบบข้อมูลที่ใช้แสดงผล
  def as_display_json
    {
      id: id,
      user_email: user.email,
      action: action,
      time: created_at.strftime("%Y-%m-%d %H:%M:%S"),
    }
  end
end
