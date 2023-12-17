class AddAddressToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :address, :text
    add_column :users, :mobile_number, :bigint
  end
end
