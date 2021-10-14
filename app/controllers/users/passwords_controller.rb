class Users::PasswordsController < Devise::PasswordsController
  include WithLocale
  include Users::AddUniversityToRequestParams

  def update
    super do |resource|
      I18n.locale = resource.language.iso_code.to_sym if resource&.persisted?
    end

    if resource.errors.empty? && Devise.sign_in_after_reset_password && resource.need_two_factor_authentication?(warden.request)
      warden.session(resource_name)[TwoFactorAuthentication::NEED_AUTHENTICATION] = true
      resource.send_new_otp
    end
  end
end
