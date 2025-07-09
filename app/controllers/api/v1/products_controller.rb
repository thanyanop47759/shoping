module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_user, only: [:index, :create, :destroy]

      def index
        result = User.find_products_for_admin_or_user(@current_user, params[:user_id])

        if result[:success]
          render json: result[:products]
        else
          render json: { success: false, message: result[:message] }, status: :forbidden
        end
      end

      def public_view
        user = User.find_by(id: params[:user_id])
        unless user
          render json: { success: false, message: "ไม่พบผู้ใช้" }, status: :not_found
          return
        end

        token = request.headers["Authorization"]
        requester = token.present? ? User.find_by(auth_token: token) : nil

        visible = user.visible_products_for(requester)

        if visible
          render json: visible
        else
          render json: { success: false, message: "คุณไม่มีสิทธิ์ดูสินค้าของผู้อื่น" }, status: :forbidden
        end
      end

      def create
        product = @current_user.products.build(product_params)
        if product.save
          render json: { success: true, product: product }, status: :created
        else
          render json: { success: false, errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        product = Product.find_by(id: params[:id])
        if product.nil?
          render json: { success: false, message: "ไม่พบสินค้า" }, status: :not_found
        elsif product.destroyable_by?(@current_user)
          product.destroy
          render json: { success: true, message: "ลบสินค้าเรียบร้อยแล้ว" }
        else
          render json: { success: false, message: "คุณไม่มีสิทธิ์ลบสินค้านี้" }, status: :forbidden
        end
      end

      private

      def product_params
        params.require(:product).permit(:name, :quantity, :category_id, :price)
      end

      def authenticate_user
        token = request.headers["Authorization"]
        @current_user = User.find_by(auth_token: token)
        unless @current_user
          render json: { success: false, message: "กรุณาเข้าสู่ระบบก่อน" }, status: :unauthorized
        end
      end
    end
  end
end
