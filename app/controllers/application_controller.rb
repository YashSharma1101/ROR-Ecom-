class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :create_cart
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  private

  def create_cart
    if current_user
      current_user.create_cart unless current_user.cart
    end
  end

end
