class Users::RegistrationsController < Devise::RegistrationsController
  include ActiveHashcash
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  invisible_captcha only: [:create], honeypot: :osuny_verification

  before_action :check_hashcash, only: :create
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :confirm_two_factor_authenticated, except: [:new, :create, :cancel]

  def new
    super do |resource|
      prefill_from_invitation(resource)
    end
  end

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

  def build_resource(hash = {})
    super
    resource.invitation = invitation
  end

  def prefill_from_invitation(resource)
    return if invitation.blank?
    resource.email = invitation.to_email
    resource.mobile_phone = invitation.person&.phone_mobile
    person_l10n = invitation.person&.best_localization_for(current_language)
    resource.first_name = person_l10n&.first_name
    resource.last_name = person_l10n&.last_name
  end

  def invitation
    return @invitation if defined?(@invitation)
    token = params[:invitation_token]
    @invitation = token.present? ? current_extranet&.invitations&.find_by(token: token) : nil
  end

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile_phone, :language_id, :first_name, :last_name, :optin_newsletter, :picture, :picture_infos, :picture_delete])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id, :first_name, :last_name, :optin_newsletter, :picture, :picture_infos, :picture_delete, :admin_theme])
  end

  def sign_up_params
    devise_parameter_sanitized = devise_parameter_sanitizer.sanitize(:sign_up).merge(registration_context: current_context)
  end

  def confirm_two_factor_authenticated
    return if is_fully_authenticated?
    flash[:alert] = t('devise.failure.unauthenticated')
    redirect_to user_two_factor_authentication_url
  end

  def hashcash_after_failure
    redirect_to(new_user_registration_path, alert: t("active_hashcash.error_label"))
  end
end
