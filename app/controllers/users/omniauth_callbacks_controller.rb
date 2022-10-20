class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery except: :saml
  before_action :redirect_unless_university_has_sso
  skip_before_action :verify_authenticity_token, only: :saml

  def saml
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    ###############################################################################
    # response.name_id : "pierreandre.boissinot@noesya.coop"
    # response.attributes.all : {"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"=>["Pierre-André"], "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"=>["Boissinot"], "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"=>["paboissinot@lespoupees.paris"], "b2bylon_role"=>["superadmin"], "language"=>["fr"], "interests"=>["interest_1", "interest_3"]}
    ###############################################################################
    puts response.name_id
    puts response.attributes.to_s
    puts response.to_s
    manage_user(response.attributes.all)
  end

  def saml_setup
    # SAML config is stored in current brand
    request.env['omniauth.strategy'].options[:issuer] = "#{user_saml_omniauth_authorize_url}/metadata"
    request.env['omniauth.strategy'].options[:idp_sso_target_url] = current_context.sso_target_url
    request.env['omniauth.strategy'].options[:idp_cert] = current_context.sso_cert
    request.env['omniauth.strategy'].options[:name_identifier_format] = current_context.sso_name_identifier_format

    render plain: "Omniauth SAML setup phase.", status: 404
  end

  private

  def manage_user(user_infos)
    @user = User.from_omniauth(current_context, user_infos)

    if @user&.persisted?
      @user.remember_me = true
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:notice] = t('devise.omniauth_callbacks.failure')
      redirect_to new_user_session_url
    end
  end

  def redirect_unless_university_has_sso
    redirect_to root_path and return unless current_context.has_sso?
  end
end
