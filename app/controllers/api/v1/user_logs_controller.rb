module Api
  module V1
    class UserLogsController < ApplicationController
      before_action :authenticate_admin

      def index
        logs = UserLog.includes(:user).order(created_at: :desc).limit(100)
        render json: logs.map { |log|
          {
            id: log.id,
            user_email: log.user.email,
            action: log.action,
            time: log.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          }
        }
      end

      private

      def authenticate_admin
        token = request.headers["Authorization"]
        user = User.find_by(auth_token: token)
        unless user&.admin?
          render json: { success: false, message: "เฉพาะแอดมินเท่านั้น" }, status: :unauthorized
        end
      end
    end
  end
end
