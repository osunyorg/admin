class Admin::Education::DashboardController < Admin::Education::ApplicationController

  def index
    raise_403_unless feature_education?
    @namespace = Education
    @hero_summary = true
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
