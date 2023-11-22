class VerifyOrderJob < ApplicationJob
  queue_as :default

  def perform(user)
    OrderMailer.out_for_delivery_email(user).deliver_now
  end
  
end
