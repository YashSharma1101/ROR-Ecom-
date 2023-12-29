class AddValidityTimeToCoupons < ActiveRecord::Migration[6.1]
  def change
    add_column :coupons, :validity_time, :datetime
  end
end
