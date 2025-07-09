Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :coupons, only: [:index, :create, :show]
      # ✅ carts controller
      resources :carts do
        collection do
          post :add_item
          post :checkout
        end
      end

      # ✅ products controller
      resources :products

      # ✅ categories controller
      resources :categories, only: [:index, :create]

      # ✅ cart_items controller
      resources :cart_items, only: [:create]

      # ✅ user_logs controller
      resources :user_logs, only: [:index]

      # ✅ routes พิเศษ
      get "public_products/:user_id", to: "products#public_view"
      post "register", to: "auth#register"
      post "login", to: "auth#login"
      get "admin/user_logs/today", to: "user_logs#today_logins"
    end
  end
end
