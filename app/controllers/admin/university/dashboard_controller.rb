class Admin::University::DashboardController < Admin::University::ApplicationController

  def index
    raise_403_unless feature_settings?
    @namespace = University
    @hero_summary = true
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
