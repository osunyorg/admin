class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :authenticate_user!

  protected

  def breadcrumb
    add_breadcrumb 'Tableau de bord', :admin_root_path
  end
end
