class CartStripePaymentService
	def initialize(cart)
		@cart = cart
	end
	def create_cart_checkout_session(success_url, cancel_url)
    line_items = @cart.cart_items.map do |cart_item|
      {
        price_data: {
          currency: 'inr',
          product_data: {
            name: cart_item.product.name,
          },
          unit_amount: (cart_item.product.price * 100).to_i,
        },
        quantity: cart_item.quantity,
      }
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