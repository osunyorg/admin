class Adminserver::ApplicationController < ApplicationController
  layout 'adminserver/layouts/application'

  before_action :authenticate_user!

  protected

  def breadcrumb
    add_breadcrumb 'Tableau de bord', :adminserver_root_path
  end
end
