class Admin::Education::DashboardController < Admin::Education::ApplicationController

  def index
    raise_403_unless feature_education?
    @namespace = Education
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
