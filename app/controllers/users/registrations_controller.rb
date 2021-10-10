class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :set_university, only: :create
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  protected

  def set_university
    return if request.params[:user].nil?
    request.params[:user][:university_id] = current_university.id
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:language_id])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id])
  end
end
