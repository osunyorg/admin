class Admin::University::DashboardController < Admin::University::ApplicationController

  def index
    raise_403_unless feature_settings?
    @namespace = University
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
