Rails.application.routes.draw do
  # เรียก devise_for :users ครั้งเดียว และให้อยู่ **นอก** namespace เสมอ

  namespace :api do
    namespace :v1 do
      # Carts resource และ custom action checkout แบบ collection
      resources :carts do
        collection do
          post "checkout"
        end
      end

      # Products resource
      resources :products

      # Categories resource
      resources :categories, only: [:index, :create]

      # CartItems resource
      resources :cart_items, only: [:create]

      # UserLogs resource
      resources :user_logs, only: [:index]

      # Custom routes
      get "public_products/:user_id", to: "products#public_view"
      post "register", to: "auth#register"
      post "login", to: "auth#login"
      get "admin/user_logs/today", to: "user_logs#today_logins"

      # ลบ post "checkout", to: "checkout#create" ออก
      # หรือถ้าต้องการให้แยกจาก carts#checkout ต้องเปลี่ยนชื่อ path ให้ไม่ซ้ำกัน
    end
  end
end
