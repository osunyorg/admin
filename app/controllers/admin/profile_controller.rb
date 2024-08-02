class Admin::ProfileController < Admin::ApplicationController
  include UserManagement

  def edit
    breadcrumb
  end

  def update
    if update_user(user_params)
      bypass_sign_in current_user, scope: :user if sign_in_after_change_password?
      redirect_to admin_profile_path, notice: t('admin.successfully_updated_html', model: current_user.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    sign_out
    redirect_to root_path
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('menu.edit_profile')
  end
end
