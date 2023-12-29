require 'stripe'
class OrdersController < ApplicationController
  include OrdersHelper
  protect_from_forgery with: :exception, except: :verify_submit
  # skip_before_action :verify_authenticity_token, only: :verify_submit

  def show
    @order = current_user.orders.find_by(id: params[:id])
  end


  def confirm_order
    user = User.find_by(id: current_user)
    if user.address.present? && user.mobile_number.present? 
      @product = Product.find(params[:product_id])
    else
      redirect_to edit_user_registration_path, notice: "To purchase a product, Please complete your profile first."
    end
  end
  
  def place_order
    product = Product.find(params[:product_id])
    product_image_url = url_for(product.image)
    coupon_discount_percentage = session[:coupon_discount_percentage]
    
    if coupon_discount_percentage
      discounted_price = calculate_discounted_price(product.price, coupon_discount_percentage)
      gst = (discounted_price.to_i * 0.18).round(2)
      final_price = (discounted_price+gst).round(2).to_i
      stripe_service = DirectStripePayment.new(product, product_image_url, final_price)
    else
      discounted_price = product.price
      gst = (discounted_price * 0.18).round(2)
      final_price = (discounted_price+gst).round(2).to_i
      stripe_service = DirectStripePayment.new(product, product_image_url, final_price)
    end
    
    stripe_session = stripe_service.create_order_checkout_session(
      order_success_url(product_id: product.id),
      confirm_order_url(product_id: product.id)
    )
    
    render json: { id: stripe_session.id }
  end

  def order_success
    product = Product.find(params[:product_id])
    coupon_discount_percentage = session[:coupon_discount_percentage]
    coupon_code = session[:coupon_code]
    discounted_price =  if coupon_discount_percentage
                          calculate_discounted_price(product.price, coupon_discount_percentage)
                        else
                          product.price
                        end
    gst = (discounted_price * 0.18).round(2)
    total_price = (discounted_price + gst).round(2)
    order = current_user.orders.create(
    order_price: product.price,
    total_price: total_price,
    total_gst: gst,
    status: :ordered,
    discounted_price: discounted_price,
    discount: product.price - discounted_price, # Store the discount applied
    coupon_code: coupon_code,
    coupon_discount_percentage: coupon_discount_percentage
  )
    order.order_items.create(product: product, quantity: 1)
    InvoiceJob.perform_later(order.id, current_user.email)
    session[:coupon_code] = nil
    session[:coupon_discount_percentage] = nil
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

  def check_coupon
    @product = Product.find(params[:product_id])
    if params[:coupon_code].present?
      coupon = Coupon.find_by(code: params[:coupon_code])
      session[:coupon_code] = params[:coupon_code]
      @coupon_code = params[:coupon_code]
      if coupon && coupon.valid_for_product?(@product)
        @coupon_discount_percentage = coupon.discount_percentage
        @message = "Coupon applied successfully! Discount: #{@coupon_discount_percentage}%"
        session[:coupon_discount_percentage] = @coupon_discount_percentage
        # flash.now[:notice] = "Coupon applied successfully! Discount: #{@coupon_discount_percentage}%"
      else
        @message = "Invalid coupon code. Please enter a valid coupon code."
        session[:coupon_discount_percentage] = nil
        @coupon_discount_percentage = nil
      end
    else
      @message = "Please enter a coupon code."
      session[:coupon_discount_percentage] = nil
      @coupon_discount_percentage = nil
    end

    respond_to do |format|
      format.html { render 'confirm_order' }
      format.json { render json: { notice: flash.now[:notice], alert: flash.now[:alert] } }
    end
  end

  def calculate_discounted_price(original_price, discount_percentage)
    discounted_price = original_price * (1 - discount_percentage / 100.0)
    discounted_price.round(2)
  end
  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def authenticity_token
    form_authenticity_token
  end
end