class Users::RegistrationsController < Devise::RegistrationsController
  include Users::AddUniversityToRequestParams
  include Users::LayoutChoice

  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  def edit
    add_breadcrumb t('admin.dashboard'), :admin_root_path
    if can? :read, @user
      add_breadcrumb User.model_name.human(count: 2), admin_users_path
      add_breadcrumb @user, [:admin, @user]
      add_breadcrumb t('edit')
    else
      add_breadcrumb t('menu.profile')
    end
  end

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

  def sign_up(resource_name, resource)
    sign_in(resource, event: :authentication)
  end

  def update_resource(resource, params)
    resource.update(params)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_infos, :picture_delete])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_infos, :picture_delete])
  end

  def sign_up_params
    devise_parameter_sanitized = devise_parameter_sanitizer.sanitize(:sign_up).merge(registration_context: current_context)
  end
end
