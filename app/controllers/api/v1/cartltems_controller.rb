class Api::V1::CartItemsController < ApplicationController
  def create
    cart = current_user.cart || current_user.create_cart
    item = cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
    item.quantity = (item.quantity || 0) + params[:quantity].to_i
    item.save

    render json: {
             id: item.id,
             product_id: item.product.id,
             product_name: item.product.name,
             quantity: item.quantity,
           }, status: :created
  end
end
