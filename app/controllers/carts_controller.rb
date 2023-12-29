class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @message = params[:message]
    @coupon_discount_percentage = params[:coupon_discount_percentage]
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
    coupon_discount_percentage = params[:coupon_discount_percentage]
    total_price = params[:total_price]
    cart = current_user.cart
    if coupon_discount_percentage
      discounted_price = calculate_cart_discounted_price(total_price, coupon_discount_percentage)
      gst = (discounted_price.to_i * 0.18).round(2)
      final_price = (discounted_price+gst).round(2)
      stripe_service = CartStripePaymentService.new(cart, coupon_discount_percentage)
    else
      discounted_price = total_price
      gst = (discounted_price * 0.18).round(2)
      final_price = (discounted_price+gst).round(2)
      stripe_service = CartStripePaymentService.new(cart, coupon_discount_percentage = nil)
    end
    # stripe_service = CartStripePaymentService.new(cart)

    session = stripe_service.create_cart_checkout_session(
      order_success_cart_url(cart_id: cart.id),
      cart_url
    )

  render json: { id: session.id }
  end

  def order_success
    byebug

    # cart = current_user.cart
    # gst = (cart.total_price * 0.18).round(2)
    # total_price = cart.total_price + gst
    # order = current_user.orders.create(order_price: cart.total_price, total_price: total_price, total_gst: gst, status: :ordered)
    cart = current_user.cart
    coupon_discount_percentage = session[:coupon_discount_percentage]
    coupon_code = session[:coupon_code]
    discounted_price =  if coupon_discount_percentage
                          calculate_cart_discounted_price(cart.total_price, coupon_discount_percentage)
                        else
                          cart.total_price - (cart.total_price*0.02).round
                        end
    gst = (discounted_price * 0.18).round(2)
    total_price = discounted_price + gst
    order = current_user.orders.create(
      order_price: cart.total_price,
      total_price: total_price,
      total_gst: gst,
      status: :ordered,
      discounted_price: discounted_price,
      discount: cart.total_price - discounted_price, 
      coupon_code: coupon_code,
      coupon_discount_percentage: coupon_discount_percentage
    )

    cart.cart_items.each do |cart_item|
      order.order_items.create(product: cart_item.product, quantity: cart_item.quantity)
      cart_item.destroy
    end

    cart.destroy 
    InvoiceJob.perform_later(order.id, current_user.email)
    session[:coupon_discount_percentage] = nil
    session[:coupon_code] = nil 
    redirect_to order_path(order), notice: "Order placed successfully. Your Order ID is: #{order.id}."
  end

  def check_cart_coupon
    if params[:coupon_code].present?
      coupon = Coupon.find_by(code: params[:coupon_code])
      session[:coupon_code] = params[:coupon_code]
      @coupon_code = params[:coupon_code]
      if coupon #&& coupon.valid_for_product?(@product)
        @coupon_discount_percentage = coupon.discount_percentage
        @message = "Coupon applied successfully! Discount: #{@coupon_discount_percentage}%"
        session[:coupon_discount_percentage] = @coupon_discount_percentage
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
      format.html { redirect_to cart_path(message: @message, coupon_discount_percentage: @coupon_discount_percentage, coupon_code: @coupon_code) }
      format.json { render json: { notice: flash.now[:notice], alert: flash.now[:alert] } }
    end
  end

  def calculate_cart_discounted_price(original_price, discount_percentage)
    byebug
    discounted_price = original_price * (1 - discount_percentage / 100.0)
    discounted_price.round(2)
  end
end
