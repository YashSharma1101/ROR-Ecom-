class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def edit
    super
  end

  def update
    super
  end

  def create
    super do |user|
      if user.errors.empty?
        @hide_navigation_links = true
        redirect_to users_confirmations_verify_otp_path(email: user.email), notice: "Enter the OTP sent to Your Email Account." and return
        #TwilioService.send_sms('+917987781031', 'Hiii ')
      end
      SendEmailsJob.perform_later(user) if user.persisted?
      #TwilioService.send_sms('+917987781031', 'Hiii ')
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :address, :email, :mobile_number])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :email, :mobile_number])
  end
end
