class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource through: :current_university

  has_scope :for_role
  has_scope :for_search_term

  def index
    @filters = ::Filters::User.new(current_user).list
    @users = apply_scopes(@users).ordered.page(params[:page])
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
    # we don't want the confirmation mail to be send when the user is created from admin!
    @user.skip_confirmation!
    @user.modified_by = current_user
    if @user.save
      redirect_to [:admin, @user], notice: t('admin.successfully_created_html', model: @user.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user.modified_by = current_user
    manage_password
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
          .permit(:email, :first_name, :last_name, :role, :password, :language_id, :picture, :picture_delete, :picture_infos, :mobile_phone, programs_to_manage_ids: [], websites_to_manage_ids: [])
          .merge(university_id: current_university.id)
  end

  def manage_password
    # to prevent cognitive complexity (the bottom block should be in an if condition where password present)
    # Password not provided when user from sso
    params[:user][:password] ||= ''

    if params[:user][:password].empty?
      params[:user].delete(:password)
    else
      @user.reset_password(params[:user][:password], params[:user][:password])
    end
  end
end
