class Users::RegistrationsController < Devise::RegistrationsController
  include WithLocale
  include Users::AddUniversityToRequestParams

  layout 'admin/layouts/application', only: [:edit, :update]

  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  def update
    # to prevent cognitive complexity (the bottom block should be in an if condition where password present)
    # Password not provided when user from sso
    params[:user][:password] ||= ''

    if params[:user][:password].empty?
      params[:user].delete(:password)
    else
      resource.reset_password(params[:user][:password], params[:user][:password])
    end

    super do |resource|
      # Re-set I18n.locale in case of language change.
      I18n.locale = resource.language.iso_code.to_sym
    end
  end

  protected

  def update_resource(resource, params)
    resource.update(params)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:language_id, :first_name, :last_name, :picture, :picture_delete])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_delete])
  end
end
