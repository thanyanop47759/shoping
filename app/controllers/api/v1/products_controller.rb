module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_user, only: [:index, :create, :destroy]

      # ✅ ดูสินค้าของตัวเอง หรือ admin ดูทั้งหมด
      def index
        if @current_user.admin?
          if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user
              render json: user.products
            else
              render json: { success: false, message: "ไม่พบผู้ใช้" }, status: :not_found
            end
          else
            products = Product.all
            render json: products
          end
        else
          if params[:user_id] && params[:user_id].to_i != @current_user.id
            render json: { success: false, message: "คุณไม่มีสิทธิ์เข้าถึงสินค้าของผู้อื่น" }, status: :forbidden
          else
            products = @current_user.products
            render json: products
          end
        end
      end

      def product_params
        params.require(:product).permit(:name, :quantity, :category_id, :price)
      end

      # ✅ ทุกคน (login หรือไม่ก็ได้) เข้าดูได้ แต่จำกัดสิทธิ์ตามสถานะ
      def public_view
        user = User.find_by(id: params[:user_id])

        if user.nil?
          render json: { success: false, message: "ไม่พบผู้ใช้" }, status: :not_found
          return
        end

        # ตรวจสอบ token หากมี
        token = request.headers["Authorization"]
        current_user = User.find_by(auth_token: token) if token.present?

        if current_user&.admin?
          render json: user.products
        elsif current_user&.id == user.id
          render json: user.products
        else
          render json: { success: false, message: "คุณไม่มีสิทธิ์ดูสินค้าของผู้อื่น" }, status: :forbidden
        end
      end

      # ✅ สร้างสินค้า
      def create
        product = @current_user.products.build(product_params)
        if product.save
          render json: { success: true, product: product }, status: :created
        else
          render json: { success: false, errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # ✅ ลบสินค้า
      def destroy
        product = Product.find_by(id: params[:id])

        if product.nil?
          render json: { success: false, message: "ไม่พบสินค้า" }, status: :not_found
        elsif @current_user.admin? || product.user_id == @current_user.id
          product.destroy
          render json: { success: true, message: "ลบสินค้าเรียบร้อยแล้ว" }
        else
          render json: { success: false, message: "คุณไม่มีสิทธิ์ลบสินค้านี้" }, status: :forbidden
        end
      end

      private

      def product_params
        params.require(:product).permit(:name, :quantity, :category_id)
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
