class Admin::ProfileController < Admin::ApplicationController
  include UserManagement

  before_action :set_environment_variable

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

  def optin_newsletter
    if current_user.optin_newsletter.nil?
      current_user.update(optin_newsletter: params[:optin] == 'true')
      redirect_back(fallback_location: root_path, notice: t('admin.users_alerts.optin_not_set.updated'))
    else
      redirect_back(fallback_location: root_path)
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('menu.edit_profile')
  end

  def set_environment_variable
    @hide_optin_alert = true
  end

end
