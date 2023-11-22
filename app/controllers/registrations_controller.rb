class RegistrationsController < Devise::RegistrationsController
    
  def create
    super do |user|
      #if user.persisted?
      #SendEmailsJob.perform_later(user)   
      if user.errors.empty?
        @hide_navigation_links = true
        redirect_to users_confirmations_verify_otp_path(email: user.email), notice: "Enter the OTP sent to Your Email Account." and return
        #, notice: "Enter the OTP sent to Your Email Account."
        #TwilioService.send_sms('+917987781031', 'Hiii ')
      end
    end
  end

end
