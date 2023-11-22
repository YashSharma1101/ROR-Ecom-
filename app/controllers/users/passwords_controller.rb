# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def set_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update(password_params)
      bypass_sign_in(@user) # Bypass reconfirmable to avoid email confirmation
      redirect_to root_path, notice: "Password successfully set."
    else
      render :set_password
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
