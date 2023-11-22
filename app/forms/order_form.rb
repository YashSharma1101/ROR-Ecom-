# app/forms/order_form.rb
class OrderForm
  include ActiveModel::Model

  attr_accessor :product_id, :quantity
end
