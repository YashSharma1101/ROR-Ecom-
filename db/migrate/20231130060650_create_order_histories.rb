class CreateOrderHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :order_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.float :total_price
      t.string :status

      t.timestamps
    end
  end
end
