class AddDiscountedPriceToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :discounted_price, :float
  end
end
