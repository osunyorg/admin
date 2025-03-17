class Admin::Administration::DashboardController < Admin::Administration::ApplicationController

  def index
    raise_403_unless feature_administration?
    @namespace = Administration
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
