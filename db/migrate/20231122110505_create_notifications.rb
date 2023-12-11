class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :content, null: false
      t.integer :status, default: 0
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true # If notifications are related to orders
      t.timestamps
    end
  end
end
