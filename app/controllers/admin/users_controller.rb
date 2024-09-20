class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource through: :current_university

  def index
    @users = @users.filter_by(params[:filters], current_language)
                   .ordered
                   .page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def favorite
    operation = params[:operation]
    about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    if operation == 'add'
      current_user.add_favorite(about)
    else
      current_user.remove_favorite(about)
    end
    redirect_back fallback_location: [:admin, about]
  end

  def update
    @user.modified_by = current_user
    @user.skip_reconfirmation!
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

  def current_subnav_context
    'navigation/admin/university'
  end

  def breadcrumb
    super
    add_breadcrumb University.model_name.human, admin_university_root_path if current_university.is_really_a_university?
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
          .permit(:email, :first_name, :last_name, :role, :language_id, :picture, :picture_delete, :picture_infos, :mobile_phone, programs_to_manage_ids: [], websites_to_manage_ids: [])
          .merge(university_id: current_university.id)
  end

end
