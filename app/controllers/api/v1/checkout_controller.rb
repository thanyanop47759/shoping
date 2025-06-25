module Api
  module V1
    class CheckoutController < ApplicationController
      def create
        cart = current_user.cart

        if cart.nil? || cart.cart_items.empty?
          return render json: { success: false, message: "ตะกร้าว่าง ไม่สามารถทำรายการได้" }, status: :unprocessable_entity
        end

        ActiveRecord::Base.transaction do
          order = Order.create!(user: current_user, total: 0)

          cart.cart_items.includes(:product).each do |item|
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
          cart.cart_items.destroy_all

          render json: { success: true, message: "ชำระเงินสำเร็จ", order_id: order.id }
        end
      rescue => e
        render json: { success: false, message: e.message }, status: :unprocessable_entity
      end
    end
  end
end
