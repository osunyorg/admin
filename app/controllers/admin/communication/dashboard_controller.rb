class Admin::Communication::DashboardController < Admin::Communication::ApplicationController

  def index
    @namespace = Communication
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
