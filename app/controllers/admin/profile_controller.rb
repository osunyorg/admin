class Admin::ProfileController < Admin::ApplicationController
  def edit
    breadcrumb
  end

  def update
    if current_user.update(permitted_params)
      redirect_to admin_profile_path, notice: t('admin.successfully_updated_html', model: current_user.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    redirect_to root_path
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('menu.edit_profile')
  end

  def permitted_params
    params.require(:user)
          .permit(
            :email,
            :first_name,
            :last_name,
            :language_id,
            :mobile_phone,
            :picture, :picture_infos, :picture_delete,
            :current_password, :password, :password_confirmation
          )
  end
end
