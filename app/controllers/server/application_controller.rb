class Server::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :authenticate_user!, :ensure_user_if_server_admin

  protected

  def breadcrumb
    add_breadcrumb 'Tableau de bord', :server_root_path
  end

  def ensure_user_if_server_admin
    raise CanCan::AccessDenied unless current_user.server_admin?
  end
end
