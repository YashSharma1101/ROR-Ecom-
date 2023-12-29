class CartStripePaymentService
	def initialize(cart, coupon_discount_percentage)
    @coupon_discount_percentage = coupon_discount_percentage
		@cart = cart
	end 
	def create_cart_checkout_session(success_url, cancel_url)
    if @coupon_discount_percentage
      line_items = @cart.cart_items.map do |cart_item|
        byebug
        discounted_amount = cart_item.product.price*(1 - @coupon_discount_percentage.to_f/100)
        gst = discounted_amount*0.18.round(2)
        {
          price_data: {
            currency: 'inr',
            product_data: {
              name: cart_item.product.name,
            },
            unit_amount: ((discounted_amount + gst) * 100).to_i
          },
          quantity: cart_item.quantity,
        }
      end
    else
       line_items = @cart.cart_items.map do |cart_item|
        discounted_amount = cart_item.product.price - (cart_item.product.price*0.02).round
        gst = cart_item.product.price*0.18.round(2)
        {
          price_data: {
            currency: 'inr',
            product_data: {
              name: cart_item.product.name,
            },
            unit_amount: ((discounted_amount + gst) * 100).to_i,
          },
          quantity: cart_item.quantity,
        }
      end
    end

    Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url
    )
  end
end   