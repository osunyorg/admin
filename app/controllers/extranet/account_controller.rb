class Extranet::AccountController < Extranet::ApplicationController
  include UserManagement

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
    if update_user(user_params)
      bypass_sign_in current_user, scope: :user if sign_in_after_change_password?
      redirect_to account_path, notice: t('extranet.account.updated')
    else
      breadcrumb
      add_breadcrumb t('extranet.account.edit')
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
  end
end
