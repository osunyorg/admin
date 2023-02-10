class Admin::Administration::DashboardController < Admin::Administration::ApplicationController

  def index
    @namespace = Administration
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
