class AddGstToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :order_price, :float
    add_column :orders, :total_gst, :float
    add_column :orders, :discount, :float
  end
end
