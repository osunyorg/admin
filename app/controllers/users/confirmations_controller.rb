class Users::ConfirmationsController < Devise::ConfirmationsController
  include Users::AddUniversityToRequestParams

  def resend
    unless signed_in_resource.confirmed?
      signed_in_resource.resend_confirmation_instructions
      redirect_back(fallback_location: admin_root_path, notice: t('devise.confirmations.send_instructions'))
    else
      redirect_back(fallback_location: admin_root_path, alert: t('admin.users_alerts.already_confirmed'))
    end
  end
end
