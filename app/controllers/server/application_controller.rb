class Server::ApplicationController < ApplicationController
  layout 'server/layouts/application'

  include Admin::Filterable

  before_action :authenticate_user!, :ensure_user_if_server_admin

  protected

  def current_admin_theme
    'pure'
  end

  def breadcrumb
    add_breadcrumb t('server_admin.dashboard'), :server_root_path
  end

  def ensure_user_if_server_admin
    raise CanCan::AccessDenied unless current_user.server_admin?
  end
end
