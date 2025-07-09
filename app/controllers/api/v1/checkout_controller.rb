module Api
  module V1
    class CheckoutController < ApplicationController
      def create
        cart = current_user.cart

        if cart.nil?
          render json: { success: false, message: "ไม่พบตะกร้าของผู้ใช้" }, status: :unprocessable_entity
          return
        end

        result = cart.checkout_to_order

        if result[:success]
          render json: result, status: :ok
        else
          render json: { success: false, message: result[:message] }, status: :unprocessable_entity
        end
      end
    end
  end
end
