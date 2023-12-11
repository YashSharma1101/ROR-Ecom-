class OrderMailer < ApplicationMailer
  def out_for_delivery_email(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: 'Your Order is Out for Delivery, Verify Your Order')
  end
end
