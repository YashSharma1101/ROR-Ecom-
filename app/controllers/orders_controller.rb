require 'stripe'
class OrdersController < ApplicationController
  protect_from_forgery with: :exception, except: :verify_submit

  # skip_before_action :verify_authenticity_token, only: :verify_submit

  def show
    @order = current_user.orders.find_by(id: params[:id])
  end


  def confirm_order
    @product = Product.find(params[:product_id])
  end
  
  def place_order
    product = Product.find(params[:product_id])
    product_image_url = url_for(product.image)
    stripe_service = DirectStripePayment.new(product, product_image_url)
    session = stripe_service.create_order_checkout_session(
      order_success_url(product_id: product.id),
      confirm_order_url(product_id: product.id)
    )
    render json: { id: session.id }
  end

  def order_success
    product = Product.find(params[:product_id])
    order = current_user.orders.create(total_price: product.price, status: :ordered)
    order.order_items.create(product: product, quantity: 1)
    InvoiceJob.perform_later(order.id, current_user.email)
    redirect_to order_path(order), notice: "#{product.name} ordered successfully. Your Order ID is #{order.id}."
  end

  def verify
    @order = current_user.orders.find(params[:id])
  end

  def mark_delivered
    @order = current_user.orders.find(params[:id])
    @order.update(status: :delivered)
    session[:order_marked_delivered] = true
    flash[:success] = "Order marked as delivered."
    redirect_to order_path(@order)
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def authenticity_token
    form_authenticity_token
  end

end
