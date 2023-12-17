class DirectStripePayment
  def initialize(product, product_image_url, discounted_price)
    @product = product
    @product_image_url = product_image_url
    @discounted_price = discounted_price
  end

  def create_order_checkout_session(success_url, cancel_url)
    line_items = [{
      price_data: {
        currency: 'inr',
        product_data: {
          name: @product.name,
        },
        unit_amount: (@discounted_price * 100).to_i,
      },
      quantity: 1,
    }]

    Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url
    )
  end
end
