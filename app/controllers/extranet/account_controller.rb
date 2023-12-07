class Extranet::AccountController < Extranet::ApplicationController
  def show
    # Admin or Superadmins can have NO person
    @person = current_user.person
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('extranet.account.edit')
  end

  def update
    if update_user(current_user, user_params)
      bypass_sign_in current_user, scope: :user if sign_in_after_change_password?
      redirect_to account_path, notice: t('extranet.account.updated')
    else
      breadcrumb
      add_breadcrumb t('extranet.account.edit')
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def update_user(user, params)
    if params[:password].blank?
      params.delete(:current_password)
      user.update_without_password(params)
    else
      user.update_with_password(params)
    end
  end

  def user_params
    params.require(:user)
          .permit(
            :first_name, :last_name, :email, :mobile_phone, :language_id,
            :current_password, :password, :password_confirmation,
            :picture, :picture_infos, :picture_delete
          )
  end

  def sign_in_after_change_password?
    return true if user_params[:password].blank?
    Devise.sign_in_after_change_password
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
  end
end
