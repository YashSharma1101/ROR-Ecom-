# frozen_string_literal: true

# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController

  def verify_otp
    user = User.find_by_email(params[:email]) # Find user by email
    entered_otp = params[:otp]
    
    #if user && user.valid_otp?(entered_otp)
    if user && user.otp===entered_otp
      user.update(email_verified: true)
      user.clear_otp! 
      sign_in(user)   
      redirect_to root_path, notice: "OTP verified. You are now logged in."

    else
         @hide_navigation_links = true
         flash.now[:alert] = "Invalid OTP. Please try again."
         render "users/confirmations/verify_otp" 
    end

  end

  # before_action :configure_sign_in_params, only: [:create]
  

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
