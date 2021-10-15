class Server::ApplicationController < ApplicationController
  layout 'server/layouts/application'

  before_action :authenticate_user!, :ensure_user_if_superadmin

  protected

  def breadcrumb
    add_breadcrumb 'Tableau de bord', :server_root_path
  end

  def ensure_user_if_superadmin
    raise CanCan::AccessDenied unless current_user.superadmin?
  end
end
