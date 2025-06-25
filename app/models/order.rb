class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart
  belongs_to :product
  has_many :order_items
end
