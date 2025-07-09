# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category

  def destroyable_by?(user)
    user&.admin? || user&.id == self.user_id
  end
end
