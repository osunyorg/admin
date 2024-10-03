class Users::RegistrationsController < Devise::RegistrationsController
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :confirm_two_factor_authenticated, except: [:new, :create, :cancel]

  def edit
    # this action is not used anymore, replaced for both universities and extranets.
    # so we redirect to the appropriate profile edition
    case current_mode
    when 'extranet'
      redirect_to edit_account_path(lang: current_language)
    when 'university'
      redirect_to admin_profile_path(lang: current_language)
    end
  end

  protected

  def sign_up(resource_name, resource)
    sign_in(resource, event: :authentication)
  end

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_infos, :picture_delete])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_infos, :picture_delete, :admin_theme])
  end

  def sign_up_params
    devise_parameter_sanitized = devise_parameter_sanitizer.sanitize(:sign_up).merge(registration_context: current_context)
  end

  def confirm_two_factor_authenticated
    return if is_fully_authenticated?
    flash[:alert] = t('devise.failure.unauthenticated')
    redirect_to user_two_factor_authentication_url
  end
end
