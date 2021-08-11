class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :set_university, only: :create
  before_action :configure_sign_up_params, only: :create

  protected

  def set_university
    return if request.params[:user].nil?
    request.params[:user][:university_id] = current_university.id
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:university_id])
  end
end
