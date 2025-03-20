class Users::SessionsController < Devise::SessionsController
  include ActiveHashcash
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  invisible_captcha only: [:create], honeypot: :osuny_verification

  before_action :check_hashcash, only: :create

  # DELETE /resource/sign_out
  def destroy
    current_user.invalidate_all_sessions!
    super
  end

  protected

  def hashcash_after_failure
    redirect_to(new_user_session_path, alert: t("active_hashcash.error_label"))
  end

end
