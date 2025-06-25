class ApplicationController < ActionController::API
  def current_user
    User.first # หรือเลือก user ที่คุณต้องการทดสอบ
  end
end
