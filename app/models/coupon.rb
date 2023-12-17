class Coupon < ApplicationRecord
  # validates :code, presence: true, uniqueness: true
  # validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  def valid_for_product?(product)
    return true
  end
end
