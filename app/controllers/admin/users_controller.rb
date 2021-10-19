class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @users = current_university.users.ordered
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @user.save
      redirect_to [:admin, @user], notice: t('admin.successfully_created_html', model: @user.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user.modified_by = current_user
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: t('admin.successfully_updated_html', model: @user.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def unlock
    if @user.access_locked? || @user.max_login_attempts?
      @user.unlock_access!
      @user.unlock_mfa!
      redirect_back(fallback_location: [:admin, @user], notice: t('admin.users_alerts.successfully_unlocked_html', model: @user.to_s))
    else
      redirect_back(fallback_location: [:admin, @user], alert: t('admin.users_alerts.not_locked_html', model: @user.to_s))
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: t('admin.successfully_destroyed_html', model: @user.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb User.model_name.human(count: 2), admin_users_path
    if @user
      if @user.persisted?
        add_breadcrumb @user, [:admin, @user]
      else
        add_breadcrumb t('create')
      end
    end
  end

  def user_params
    params.require(:user)
          .permit(:email, :first_name, :last_name, :role, :language_id, :picture, :picture_delete, :picture_infos, :mobile_phone)
          .merge(university_id: current_university.id)
  end
end
