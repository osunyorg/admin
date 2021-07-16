class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
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
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: "User was successfully created." }
        format.json { render :show, status: :created, location: [:admin, @user] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    breadcrumb
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, @user], notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: [:admin, @user] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
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
    params.require(:user).permit(:first_name, :last_name, :role)
  end
end
