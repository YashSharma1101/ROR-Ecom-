module CartsHelper
  def calculate_cart_discounted_price(original_price, discount_percentage)
    discount = (original_price * discount_percentage / 100).round(2)
    discounted_price = original_price - discount
    discounted_price
  end
end
