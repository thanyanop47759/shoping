module Api
  module V1
    class ApplicationController < ActionController::API
      private

      def authenticate_user
        auth_header = request.headers["Authorization"]
        token = auth_header.present? ? auth_header.split(" ").last : nil

        Rails.logger.info("[Authenticate_user] Token extracted: #{token.inspect}")

        @current_user = User.find_by(auth_token: token)
        if @current_user.nil?
          Rails.logger.info("[Authenticate_user] No user found with token: #{token.inspect}")
          render json: { success: false, message: "กรุณาเข้าสู่ระบบก่อน" }, status: :unauthorized
        end
      end
    end
  end
end
