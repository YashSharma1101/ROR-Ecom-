class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    if current_user.cart
      cart_item = current_user.cart.cart_items.find_or_initialize_by(product: product)
      cart_item.quantity = 1
      if cart_item.save
        redirect_to cart_path, notice: "#{product.name} added to cart."
      else
        redirect_to root_path, alert: "Error adding product to cart."
      end
    else
      redirect_to root_path, alert: "No cart found for current user."
    end
  end

  def increase_quantity
    cart_item = CartItem.find(params[:cart_item_id])
    cart_item.increment!(:quantity)
    redirect_to cart_path, notice: "#{cart_item.product.name} quantity increased."
  end

  def decrease_quantity
    cart_item = CartItem.find(params[:cart_item_id])
    if cart_item.quantity > 1
      cart_item.decrement!(:quantity)
      redirect_to cart_path, notice: "#{cart_item.product.name} quantity decreased."
    else
      cart_item.destroy
      redirect_to cart_path, notice: "#{cart_item.product.name} removed from cart."
    end
  end

  def remove_from_cart
    cart_item = CartItem.find(params[:cart_item_id])
    cart_item.destroy
    redirect_to cart_path, notice: "#{cart_item.product.name} removed from cart."
  end

  def place_order
    cart = current_user.cart
    stripe_service = CartStripePaymentService.new(cart)

    session = stripe_service.create_cart_checkout_session(
      order_success_cart_url(cart_id: cart.id),
      cart_url
    )

  render json: { id: session.id }
  end
  def order_success
    cart = current_user.cart
    order = current_user.orders.create(total_price: cart.total_price, status: :ordered)

    cart.cart_items.each do |cart_item|
      order.order_items.create(product: cart_item.product, quantity: cart_item.quantity)
      cart_item.destroy
    end

    cart.destroy 
    InvoiceJob.perform_later(order.id, current_user.email)
    redirect_to order_path(order), notice: "Order placed successfully. Your Order ID is: #{order.id}."
  end
end
