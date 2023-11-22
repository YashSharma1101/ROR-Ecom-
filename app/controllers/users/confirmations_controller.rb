# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
  # def create
  #   # Standard Devise confirmation create action
  #   self.resource = resource_class.send_confirmation_instructions(resource_params)

  #   # Custom code to send OTP
  #   resource.generate_otp
  #   resource.save
  #   # Send the OTP to the user's email using Action Mailer
  #   # Similar to Devise's confirmation email, you can customize the mailer

  #   yield resource if block_given?

  #   if successfully_sent?(resource)
  #     respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
  #   else
  #     respond_with(resource)
  #   end

  #   end
  
end
