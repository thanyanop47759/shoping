class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: true

  # ✅ สร้าง category จากชื่อ
  def self.create_with_name(name)
    category = new(name: name)

    if category.save
      { success: true, category: category }
    else
      { success: false, errors: category.errors.full_messages }
    end
  end
end
