module UserManagement
  extend ActiveSupport::Concern

  protected

  def update_user(params)
    if params[:password].blank?
      params.delete(:current_password)
      current_user.update_without_password(params)
    else
      current_user.update_with_password(params)
    end
  end

  def user_params
    params.require(:user)
          .permit(
            :first_name, :last_name, :email, :mobile_phone, :language_id, :optin_newsletter,
            :current_password, :password, :password_confirmation,
            :picture, :picture_infos, :picture_delete
          )
  end

  def sign_in_after_change_password?
    return true if user_params[:password].blank?
    Devise.sign_in_after_change_password
  end
end
