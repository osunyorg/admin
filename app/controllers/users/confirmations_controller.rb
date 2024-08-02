class Users::ConfirmationsController < Devise::ConfirmationsController
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  def resend
    unless signed_in_resource.confirmed?
      signed_in_resource.resend_confirmation_instructions
      redirect_back(fallback_location: admin_root_path(lang: current_university.default_language), notice: t('devise.confirmations.send_instructions'))
    else
      redirect_back(fallback_location: admin_root_path(lang: current_university.default_language), alert: t('admin.users_alerts.already_confirmed'))
    end
  end
end
