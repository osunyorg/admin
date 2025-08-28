class Server::OptinUsersController < Server::ApplicationController
  
  def index
    @users = User.filter_by(params[:filters], current_language)
                 .where(optin_newsletter: true)
                 .ordered

    respond_to do |format|
      format.html {
        @users = @users.page(params[:page])
        breadcrumb
      }
      format.xlsx {
        filename = "optin-users-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
      }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('server_admin.optin_users.title'), server_optin_users_path
  end
  
end
