module Api
  module V1
    class CartsController < ApplicationController
      before_action :authenticate_user

      def add_item
        cart = @current_user.cart || @current_user.create_cart
        result = cart.add_item(params[:product_id], params[:quantity] || 1)

        if result[:success]
          render json: result, status: :ok
        else
          render json: { success: false, message: result[:message] || result[:errors] }, status: :unprocessable_entity
        end
      end

      def checkout
        cart = @current_user.cart

        if cart.nil?
          render json: { success: false, message: "Cart not found" }, status: :unprocessable_entity
          return
        end

        result = cart.checkout(params[:coupon_code])

        if result[:success]
          render json: result, status: :ok
        else
          render json: { success: false, message: result[:message] }, status: :unprocessable_entity
        end
      end
    end
  end
end
