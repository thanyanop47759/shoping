# app/models/product_log.rb
class ProductLog < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
