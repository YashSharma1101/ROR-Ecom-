module OrdersHelper
  def calculate_discounted_price(original_price, discount_percentage)
    discount = (original_price * discount_percentage.to_i / 100).round(2)
    discounted_price = original_price - discount
    discounted_price
  end
end
