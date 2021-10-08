class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @users = current_university.users
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
    add_breadcrumb 'Modifier'
  end

  def create
    breadcrumb
    if @user.save
      redirect_to [:admin, @user], notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    breadcrumb
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: "User was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb User.model_name.human(count: 2), admin_users_path
    if @user
      if @user.persisted?
        add_breadcrumb @user, [:admin, @user]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :language_id, :picture, :picture_delete, :mobile_phone)
  end
end
