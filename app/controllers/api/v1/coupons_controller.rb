module Api
  module V1
    class CouponsController < ApplicationController
      def index
        render json: Coupon.all
      end

      def create
        result = Coupon.safe_create(coupon_params)

        if result[:success]
          render json: { success: true, coupon: result[:coupon] }, status: :created
        else
          render json: { success: false, errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      def show
        result = Coupon.find_safe(params[:id])

        if result[:success]
          render json: result[:coupon]
        else
          render json: { success: false, message: result[:message] }, status: :not_found
        end
      end

      private

      def coupon_params
        params.permit(:code, :discount, :expires_at, :used)
      end
    end
  end
end
