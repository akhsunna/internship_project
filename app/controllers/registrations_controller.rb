class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :email, :password, :phone)
    devise_parameter_sanitizer.for(:account_update).push(:name, :email, :password, :phone)
  end
end
