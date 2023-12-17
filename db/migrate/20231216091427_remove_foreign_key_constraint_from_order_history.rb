class RemoveForeignKeyConstraintFromOrderHistory < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :order_histories, column: :user_id
  end
end
