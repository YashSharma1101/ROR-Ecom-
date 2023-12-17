class AddCouponToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :coupon_code, :string
    add_column :orders, :coupon_discount_percentage, :integer
  end
end
