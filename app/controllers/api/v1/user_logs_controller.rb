module Api
  module V1
    class UserLogsController < ApplicationController
      before_action :authenticate_admin

      def index
        logs = UserLog.recent_with_user
        render json: logs.map(&:as_display_json)
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
