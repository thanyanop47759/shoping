# app/controllers/api/v1/application_controller.rb
module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_user

      private

      def authenticate_user
        @current_user = User.find_by_token(request.headers["Authorization"])

        if @current_user.nil?
          Rails.logger.info("[Authenticate_user] ไม่พบผู้ใช้จาก token")
          render json: { success: false, message: "กรุณาเข้าสู่ระบบก่อน" }, status: :unauthorized
        end
      end
    end
  end
end
