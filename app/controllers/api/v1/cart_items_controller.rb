def create
  cart = current_user.cart || current_user.create_cart
  product = Product.find_by(id: params[:product_id])
  if product.nil?
    render json: { success: false, message: "Product not found" }, status: :not_found
    return
  end

  item = cart.cart_items.find_or_initialize_by(product_id: product.id)
  item.quantity = (item.quantity || 0) + params[:quantity].to_i

  if item.save
    render json: {
      success: true,
      item: {
        id: item.id,
        product_id: product.id,
        product_name: product.name,
        quantity: item.quantity,
      },
    }, status: :created
  else
    render json: { success: false, message: item.errors.full_messages }, status: :unprocessable_entity
  end
end
