# app/controllers/cart_items_controller.rb
def create
  cart = current_user.cart || current_user.create_cart
  result = cart.add_product(params[:product_id], params[:quantity])

  if result[:success]
    render json: result, status: :created
  else
    render json: { success: false, message: result[:message] }, status: :unprocessable_entity
  end
end
