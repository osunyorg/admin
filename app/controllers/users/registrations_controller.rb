class Users::RegistrationsController < Devise::RegistrationsController
  include Users::AddUniversityToRequestParams

  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:language_id, :first_name, :last_name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id])
  end
end
