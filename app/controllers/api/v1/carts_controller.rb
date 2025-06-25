module Api
  module V1
    class CartsController < ApplicationController
      before_action :authenticate_user

      def checkout
        cart = @current_user.cart
        if cart.nil? || cart.cart_items.empty?
          render json: { success: false, message: "Cart is empty" }, status: :unprocessable_entity
          return
        end

        cart.cart_items.destroy_all
        render json: { success: true, message: "Checkout successful" }
      end

      private

      def authenticate_user
        auth_header = request.headers["Authorization"]
        token = auth_header.present? ? auth_header.split(" ").last : nil
        @current_user = User.find_by(auth_token: token)
        unless @current_user
          render json: { success: false, message: "กรุณาเข้าสู่ระบบก่อน" }, status: :unauthorized
        end
      end
    end
  end
end
