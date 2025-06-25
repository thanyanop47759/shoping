module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user_from_token!, only: [:login, :register]

      def register
        user = User.new(user_params)
        if user.save
          user.update(auth_token: SecureRandom.hex(20))
          render json: { success: true, user: user, token: user.auth_token }, status: :created
        else
          render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          user.update(auth_token: SecureRandom.hex(20))
          render json: { success: true, token: user.auth_token, user_id: user.id }
        else
          render json: { success: false, message: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" }, status: :unauthorized
        end
      end

      def logout
        user = User.find_by(auth_token: request.headers["Authorization"])
        if user
          UserLog.create!(user_id: user.id, action: "logout")
          user.update(auth_token: nil)
          render json: { success: true, message: "ออกจากระบบเรียบร้อยแล้ว" }
        else
          render json: { success: false, message: "ไม่พบผู้ใช้งาน" }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation, :role)
      end
    end
  end
end
