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
    manage_password
    current_user.update user_params
    redirect_to account_path, notice: t('extranet.account.updated')
  end

  protected

  def manage_password
    # to prevent cognitive complexity (the bottom block should be in an if condition where password present)
    # Password not provided when user from sso
    params[:user][:password] ||= ''

    if params[:user][:password].blank?
      params[:user].delete(:password)
    else
      current_user.reset_password(params[:user][:password], params[:user][:password])
    end
  end

  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :email, :mobile_phone, :language_id, :password, :picture, :picture_infos, :picture_delete)
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
  end
end
