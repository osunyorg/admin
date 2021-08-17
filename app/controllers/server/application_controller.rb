class Server::ApplicationController < ApplicationController
  layout 'server/layouts/application'

  before_action :authenticate_user!

  protected

  def breadcrumb
    add_breadcrumb 'Tableau de bord', :server_root_path
  end
end
