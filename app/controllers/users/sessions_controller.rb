class Users::SessionsController < Devise::SessionsController
  prepend_before_action :set_university, only: :create
  before_action :configure_sign_in_params, only: :create

  protected

  def set_university
    return if request.params[:user].nil?
    request.params[:user][:university_id] = current_university.id
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:university_id])
  end
end
