# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  # เพิ่มสินค้าลงตะกร้า
def add_item(product_id, quantity = 1)
  product = Product.find_by(id: product_id)
  return { success: false, message: "ไม่พบสินค้า" } if product.nil?

  cart_item = cart_items.find_or_initialize_by(product_id: product.id)
  cart_item.quantity ||= 0
  cart_item.quantity += quantity.to_i

  if cart_item.save
    items = cart_items.includes(:product).map do |item|
      {
        product_id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        price: item.product.price,
        total_price: item.quantity * item.product.price.to_f,
      }
    end

    { success: true, message: "เพิ่มสินค้าลงตะกร้าแล้ว", cart_items: items }
  else
    { success: false, errors: cart_item.errors.full_messages }
  end
end

# เช็คเอาท์ (คำนวณราคา, ใช้คูปอง, ล้างตะกร้า)
def checkout(coupon_code = nil)
  return { success: false, message: "Cart is empty" } if cart_items.empty?

  subtotal = cart_items.joins(:product).sum("cart_items.quantity * products.price")
  discount = 0

  if coupon_code.present?
    coupon = Coupon.find_by(code: coupon_code)

    return { success: false, message: "คูปองไม่ถูกต้อง" } if coupon.nil?
    return { success: false, message: "คูปองหมดอายุแล้ว" } if coupon.expires_at.present? && coupon.expires_at < Time.current
    return { success: false, message: "คูปองถูกใช้ไปแล้ว" } if coupon.used?

    if coupon.discount_type == "percent"
      discount = (subtotal * (coupon.discount.to_f / 100.0)).round(2)
    else
      discount = coupon.discount.to_f
    end

    coupon.update(used: true)
  end

  total_price = subtotal - discount
  total_price = 0 if total_price < 0

  items = cart_items.includes(:product).map do |item|
    {
      product_id: item.product.id,
      name: item.product.name,
      quantity: item.quantity,
      unit_price: item.product.price,
      total_price: item.quantity * item.product.price.to_f,
    }
  end

  cart_items.destroy_all

  {
    success: true,
    message: "Checkout successful",
    coupon_code: coupon_code,
    discount: discount,
    subtotal: subtotal,
    total_price: total_price,
    items: items,
    checkout_time: Time.current,
  }
end

  def add_product(product_id, quantity)
    product = Product.find_by(id: product_id)
    return { success: false, message: "Product not found" } if product.nil?

    item = cart_items.find_or_initialize_by(product_id: product.id)
    item.quantity = (item.quantity || 0) + quantity.to_i

    if item.save
      {
        success: true,
        item: {
          id: item.id,
          product_id: product.id,
          product_name: product.name,
          quantity: item.quantity,
        },
      }
    else
      { success: false, message: item.errors.full_messages }
    end
  end
  def checkout_to_order
  return { success: false, message: "ตะกร้าว่าง ไม่สามารถทำรายการได้" } if cart_items.empty?

  ActiveRecord::Base.transaction do
    order = Order.create!(user: user, total: 0)

    cart_items.includes(:product).each do |item|
      if item.quantity > item.product.quantity
        raise ActiveRecord::Rollback, "สินค้า #{item.product.name} ไม่พอใน stock"
      end

      OrderItem.create!(
        order: order,
        product: item.product,
        quantity: item.quantity,
        price: item.product.price,
      )

      item.product.update!(quantity: item.product.quantity - item.quantity)
      order.total += item.quantity * item.product.price
    end

    order.save!
    cart_items.destroy_all

    { success: true, message: "ชำระเงินสำเร็จ", order_id: order.id }
  end
rescue => e
  { success: false, message: e.message }
end
end
